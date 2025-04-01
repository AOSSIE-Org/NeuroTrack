import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:patient/core/repository/auth/auth.dart';
import 'package:patient/core/utils/utils.dart';
import 'package:patient/model/auth_models/personal_info_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/result/result.dart';

enum AuthNavigationStatus {
  unknown,
  home,
  personalDetails,
  error,
}

extension AuthNavigationStatusX on AuthNavigationStatus {
  bool get isUnknown => this == AuthNavigationStatus.unknown;
  bool get isHome => this == AuthNavigationStatus.home;
  bool get isPersonalDetails => this == AuthNavigationStatus.personalDetails;
  bool get isError => this == AuthNavigationStatus.error;
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  ApiStatus _apiStatus = ApiStatus.initial;
  ApiStatus get apiStatus => _apiStatus;

  String _apiErrorMessage = '';
  String get apiErrorMessage => _apiErrorMessage;

  final supabase = Supabase.instance.client;

  AuthNavigationStatus _authNavigationStatus = AuthNavigationStatus.unknown;
  AuthNavigationStatus get authNavigationStatus => _authNavigationStatus;

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await _handleWebSignIn();
      } else {
        await _handleMobileSignIn();
      }
    } catch (error) {
      debugPrint('Sign-in failed: $error');
      throw Exception('Sign in failed: $error');
    }
  }

  Future<void> _handleWebSignIn() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ??
        (throw Exception("Supabase URL not found in .env"));

    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "$supabaseUrl/auth/v1/callback",
      authScreenLaunchMode: LaunchMode.platformDefault,
    );
  }

  Future<void> _handleMobileSignIn() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ??
        (throw Exception("GOOGLE_WEB_CLIENT_ID not found in .env"));
    final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS ? iosClientId : null,
      serverClientId: webClientId,
      scopes: ['email', 'profile'],
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw 'Sign in cancelled';

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.idToken == null) throw 'No ID Token found';
    if (googleAuth.accessToken == null) throw 'No Access Token found';

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }

  String? getFullName() {
    final session = supabase.auth.currentSession;

    if (session == null) {
      debugPrint('User not authenticated');
      return null;
    }

    debugPrint('Access Token: ${session.accessToken}');

    return session.user.userMetadata?['full_name'] ?? 'User';
  }

  Future<void> checkIfPatientExists() async {
    _authNavigationStatus = AuthNavigationStatus.unknown;
    notifyListeners();

    final ActionResult result = await _authRepository.checkIfPatientExists();

    if (result is ActionResultSuccess) {
      final bool patientExists = result.data as bool;
      _authNavigationStatus = patientExists
          ? AuthNavigationStatus.home
          : AuthNavigationStatus.personalDetails;
    } else {
      debugPrint('Error checking patient existence: ${result.errorMessage}');
      _authNavigationStatus = AuthNavigationStatus.error;
    }
    notifyListeners();
  }

  void storePatientPersonalInfo(PersonalInfoModel personalInfoModel) async {
    try {
      _apiStatus = ApiStatus.initial;
      _apiErrorMessage = '';
      notifyListeners();

      final user = supabase.auth.currentUser;
      if (user == null) {
        debugPrint('User not authenticated');
        _apiErrorMessage = 'User not authenticated. Please log in again.';
        _apiStatus = ApiStatus.failure;
        notifyListeners();
        return;
      }

      // Debugging API request details
      debugPrint('Sending Patient Info: ${personalInfoModel.toEntity()}');
      debugPrint('Access Token: ${supabase.auth.currentSession?.accessToken}');

      final ActionResult result =
          await _authRepository.storePersonalInfo(personalInfoModel.toEntity());

      if (result is ActionResultSuccess) {
        _apiStatus = ApiStatus.success;
      } else {
        debugPrint('API Error: ${result.errorMessage}');
        _apiStatus = ApiStatus.failure;
        _apiErrorMessage =
            result.errorMessage ?? 'An error occurred. Please try again.';
      }
    } catch (e, stackTrace) {
      debugPrint('Unexpected Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      _apiStatus = ApiStatus.failure;
      _apiErrorMessage = 'Something went wrong. Please try again later.';
    }
    notifyListeners();
  }

  void resetApiStatus() {
    _apiStatus = ApiStatus.initial;
    _apiErrorMessage = '';
    notifyListeners();
  }
}
