import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:patient/core/repository/auth/auth.dart';
import 'package:patient/core/utils/utils.dart';
import 'package:patient/model/auth_models/auth_model.dart';
import 'package:patient/model/auth_models/personal_info_model.dart';
import 'package:patient/model/auth_models/therapist_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/result/result.dart';


enum AuthNavigationStatus {
  unknown,
  home,
  personalDetails,
  assessment,
  initialConsultation,
  error,
}
extension AuthNavigationStatusX on AuthNavigationStatus {
  bool get isUnknown => this == AuthNavigationStatus.unknown;
  bool get isHome => this == AuthNavigationStatus.home;
  bool get isPersonalDetails => this == AuthNavigationStatus.personalDetails;
  bool get isAssessment => this == AuthNavigationStatus.assessment;
  bool get isInitialConsultation => this == AuthNavigationStatus.initialConsultation;
  bool get isError => this == AuthNavigationStatus.error;
}

class AuthProvider extends ChangeNotifier {

  AuthProvider({
    required AuthRepository authRepository,
  }): _authRepository = authRepository;

  final AuthRepository _authRepository;

  ApiStatus _apiStatus = ApiStatus.initial;
  ApiStatus get apiStatus => _apiStatus;
  
  String _apiErrorMessage = '';
  String get apiErrorMessage => _apiErrorMessage;

  final supabase = Supabase.instance.client;

  AuthNavigationStatus _authNavigationStatus = AuthNavigationStatus.unknown;
  AuthNavigationStatus get authNavigationStatus => _authNavigationStatus;

  List<TherapistModel> _therapistList = [];
  List<TherapistModel> get therapistList => _therapistList;
  set therapistList(List<TherapistModel> value) {
    _therapistList = value;
    notifyListeners();
  }

  List<String> _availableBookingSlots = [];
  List<String> get availableBookingSlots => _availableBookingSlots;
  set availableBookingSlots(List<String> value) {
    _availableBookingSlots = value;
    notifyListeners();
  }
  ApiStatus _availableBookingSlotsStatus = ApiStatus.initial;
  ApiStatus get availableBookingSlotsStatus => _availableBookingSlotsStatus;

  ApiStatus _bookConsulationStatus = ApiStatus.initial; 
  ApiStatus get bookConsulationStatus => _bookConsulationStatus;

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await _handleWebSignIn();
      } else {
        await _handleMobileSignIn();
      }
    } catch (error) {
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
      (throw Exception("WEB_CLIENT_ID not found in .env"));
    final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

    // Get the singleton instance.
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    // Initialize the GoogleSignIn instance.
    await googleSignIn.initialize(
      clientId: Platform.isIOS ? iosClientId : null,
      serverClientId: webClientId,
    );

    // Define scopes (they were moved from the constructor/initialize to the sign-in call).
    const List<String> scopes = ['email', 'profile'];

    // Sign-in logic
     final GoogleSignInAccount? googleUser = await googleSignIn.authenticate(
      scopeHint: scopes, 
    );
    if (googleUser == null) throw 'Sign in cancelled';

    // Authorization to get access token
    final authorization = await googleUser.authorizationClient.authorizeScopes(
      scopes
    );
    final String accessToken = authorization.accessToken;

    // Authentication (It now synchronous as per v7.0+).
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) throw 'No ID Token found';
    
    // Supabase login (now with the retrieved accessToken)
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  String? getFullName() {
    final session = supabase.auth.currentSession;
    if (session == null) return null;
    return session.user.userMetadata?['full_name'] ?? 'User';
  }

  Future<void> checkIfPatientExists() async {
    _authNavigationStatus = AuthNavigationStatus.unknown;
    notifyListeners();

    final result = await _authRepository.checkIfPatientExists();
    if (result is! ActionResultSuccess) {
      _setStatus(AuthNavigationStatus.error);
      return;
    }

    final bool patientExists = result.data as bool;
    if (!patientExists) {
      _setStatus(AuthNavigationStatus.personalDetails);
      return;
    }

    final assessmentResult =
        await _authRepository.checkIfPatientAssessmentExists();
    if (assessmentResult is! ActionResultSuccess) {
      _setStatus(AuthNavigationStatus.error);
      return;
    }

    final bool assessmentExists = assessmentResult.data as bool;
    if (!assessmentExists) {
      _setStatus(AuthNavigationStatus.assessment);
      return;
    }

    final consultationResult =
        await _authRepository.checkIfPatientConsultationExists();
    if (consultationResult is! ActionResultSuccess) {
      _setStatus(AuthNavigationStatus.error);
      return;
    }

    final bool consultationExists = consultationResult.data as bool;
    _setStatus(consultationExists
        ? AuthNavigationStatus.home
        : AuthNavigationStatus.initialConsultation);
  }

  void _setStatus(AuthNavigationStatus status) {
    _authNavigationStatus = status;
    notifyListeners();
  }


  void storePatientPersonalInfo(PersonalInfoModel personalInfoModel) async {
    _apiStatus = ApiStatus.initial;
    _apiErrorMessage = '';
    notifyListeners();
    final ActionResult result = await _authRepository.storePersonalInfo(personalInfoModel.toEntity());
    if(result is ActionResultSuccess) {
      _apiStatus = ApiStatus.success;
    } else {
      _apiStatus = ApiStatus.failure;
      _apiErrorMessage = result.errorMessage ?? 'An error occurred. Please try again.';
    }
    notifyListeners();
  }

  void getAllTherapist() async {
    _apiStatus = ApiStatus.initial;
    _apiErrorMessage = '';
    notifyListeners();
    final ActionResult result = await _authRepository.getAllAvailableTherapist();
      if(result is ActionResultSuccess) {
        therapistList = result.data as List<TherapistModel>;
        _apiStatus = ApiStatus.success;
      } else {
        _apiStatus = ApiStatus.failure;
        _apiErrorMessage = result.errorMessage ?? 'An error occurred. Please try again.';
        notifyListeners();
      }
  }

  void getAvailableBookingSlotsForTherapist(
    String therapistId,
    DateTime date) async {
    _availableBookingSlotsStatus = ApiStatus.initial;
    _availableBookingSlots = [];
    notifyListeners();
    final therapistData = therapistList.firstWhere((element) => element.id == therapistId);
    final ActionResult result = await _authRepository.getAvailableBookingSlotsForTherapist(
      therapistId,
      date,
      therapistData.startAvailabilityTime,
      therapistData.endAvailabilityTime,
    );
      if(result is ActionResultSuccess) {
        _availableBookingSlots = result.data as List<String>;
        _availableBookingSlotsStatus = ApiStatus.success;
        notifyListeners();
      } else {
        _availableBookingSlotsStatus = ApiStatus.failure;
        notifyListeners();
      }
  }

  void bookConsultation(String therapistId, DateTime date, int index) async  {
    final consultationModel = ConsultationRequestModel(
      timestamp: _updateTime(date, availableBookingSlots[index]),
      therapistId: therapistId,
      isConsultation: true,
      duration: 30,
      name: 'Consultation Session with the Therapist'
    );

    _bookConsulationStatus = ApiStatus.initial;

    notifyListeners();

    final ActionResult result = await _authRepository.bookConsultation(consultationModel.toEntity());

    if(result is ActionResultSuccess) {
      _bookConsulationStatus = ApiStatus.success;
      notifyListeners();
    } else {
      _bookConsulationStatus = ApiStatus.failure;
      notifyListeners();
    }
  }

 DateTime _updateTime(DateTime date, String timeStr) {
    final timeParts = timeStr.split(' ');
    final time = timeParts[0];
    final period = timeParts[1].toUpperCase();

    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  void resetNavigationStatus() {
    _authNavigationStatus = AuthNavigationStatus.unknown;
    notifyListeners();
  }

  void resetBookingSlots() {
    _availableBookingSlots = [];
    notifyListeners();
  }

  void resetApiStatus() {
    _apiStatus = ApiStatus.initial;
    _apiErrorMessage = '';
    notifyListeners();
  }
}
