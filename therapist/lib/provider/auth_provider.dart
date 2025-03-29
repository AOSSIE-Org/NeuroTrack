import 'package:flutter/material.dart';
import 'package:therapist/core/entities/auth_entities/therapist_personal_info_entity.dart';
import 'package:therapist/core/repository/auth/auth_repository.dart';
import 'package:therapist/core/result/result.dart';
import 'package:therapist/presentation/auth/personal_details_screen.dart';
import 'package:therapist/presentation/home/home_screen.dart';
import 'package:supabase/supabase.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SupabaseClient _supabaseClient;

  AuthProvider({
    required AuthRepository authRepository,
    required SupabaseClient supabaseClient,
  }) : _authRepository = authRepository,
       _supabaseClient = supabaseClient;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _userId;
  String? get userId => _userId;

  String? _userEmail;
  String? get userEmail => _userEmail;

  late String _userName;
  String get userName => _userName;

  bool _isNewUser = true;
  bool get isNewUser => _isNewUser;

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _authRepository.signInWithGoogle();

      if (result is ActionResultSuccess) {
        _isAuthenticated = true;
        _userId = await _authRepository.getUserId();
        
        final userData = result.data as Map<String, dynamic>;
        _userEmail = userData['email'];
        _userName = userData['name'];
        _isNewUser = userData['is_new_user'] ?? true; // Store if user is new
        
        _errorMessage = '';
      } else if (result is ActionResultFailure) {
        _errorMessage = result.errorMessage!;
        _isAuthenticated = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
    return _isAuthenticated;
  }

  Future<bool> storePersonalInfo(TherapistPersonalInfoEntity personalInfoEntity) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _authRepository.storePersonalInfo(personalInfoEntity);

    bool success = false;
    
    if (result is ActionResultSuccess) {
      success = true;
    } else if (result is ActionResultFailure) {
      _errorMessage = result.errorMessage!;
      success = false;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> checkAuthentication() async {
    _userId = await _authRepository.getUserId();
    _isAuthenticated = _userId != null;
    notifyListeners();
  }

  Future<bool> checkIfUserIsNew() async {
    if (_userId == null) {
      return true; 
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authRepository.checkIfUserIsNew(_userId!);
      
      if (result is ActionResultSuccess) {
        final data = result.data as Map<String, dynamic>;
        _isNewUser = data['is_new_user'] ?? true;
      } else if (result is ActionResultFailure) {
        _errorMessage = result.errorMessage!;
        _isNewUser = true;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isNewUser = true;
    }
    
    _isLoading = false;
    notifyListeners();
    return _isNewUser;
  }

  Map<String, dynamic>? getUserMetadata() {
    return _supabaseClient.auth.currentSession?.user.userMetadata;
  }

  void navigateBasedOnUserStatus(BuildContext context) {
    if (_isNewUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PersonalDetailsScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }
}
