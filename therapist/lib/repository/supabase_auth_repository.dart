import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:therapist/core/entities/auth_entities/therapist_personal_info_entity.dart';
import 'package:therapist/core/repository/auth/auth_repository.dart';
import 'package:therapist/core/result/action_result.dart';

import '../core/result/result.dart';

class SupabaseAuthRepository implements AuthRepository {

  SupabaseAuthRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Future<ActionResult> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await _handleWebSignIn();
      } else {
        await _handleMobileSignIn();
      }
      
      // After successful sign-in, check if the user exists in the therapist table
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return ActionResultFailure(
          errorMessage: 'Failed to get user after sign-in',
          statusCode: 400,
        );
      }
      
      // Query the therapist table to check if user exists
      final therapistData = await _supabaseClient
          .from('therapist')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      
      final bool isNewUser = therapistData == null;
      
      return ActionResultSuccess(
        data: {
          'id': user.id,
          'email': user.email,
          'name': user.userMetadata?['full_name'] ?? '',
          'is_new_user': isNewUser, // Add this flag
        },
        statusCode: 200,
      );
    } catch (error) {
      return ActionResultFailure(
        errorMessage: 'Sign in failed: $error',
        statusCode: 400,
      );
    }
  }

  Future<void> _handleWebSignIn() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ??
        (throw Exception("Supabase URL not found in .env"));

    await _supabaseClient.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "$supabaseUrl/auth/v1/callback",
      authScreenLaunchMode: LaunchMode.platformDefault,
    );
  }

  Future<void> _handleMobileSignIn() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ??
        (throw Exception("WEB_CLIENT_ID not found in .env"));
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
    
    await _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }

  @override
  Future<ActionResult> storePersonalInfo(TherapistPersonalInfoEntity personalInfoEntity) async {
    try {
      // Get the current authenticated user
      final currentUser = _supabaseClient.auth.currentUser;
      
      if (currentUser == null) {
        print("Error: No authenticated user found");
        return ActionResultFailure(
          errorMessage: 'No authenticated user found. Please sign in again.',
          statusCode: 401,
        );
      }
      
      // Create data with user ID explicitly set
      final data = {
        'id': currentUser.id,  // THIS IS THE KEY FIX
        ...personalInfoEntity.toMap(),
      };
      
      print("Storing therapist data with ID: ${currentUser.id}");
      
      // Use insert with the complete data including ID
      await _supabaseClient.from('therapist').insert(data);

      return ActionResultSuccess(
        data: 'Personal information stored successfully',
        statusCode: 200
      );
    } catch(e) {
      print("Error storing personal info: $e");
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return _supabaseClient.auth.currentUser?.id;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ActionResult> checkIfUserIsNew(String userId) async {
    try {
      // Query the therapist table to check if user exists
      final therapistData = await _supabaseClient
        .from('therapist')
        .select()
        .eq('id', userId)
        .maybeSingle();
      
      final bool isNewUser = therapistData == null;
      
      return ActionResultSuccess(
        data: {
          'is_new_user': isNewUser,
        },
        statusCode: 200,
      );
    } catch (e) {
      print('Error checking if user is new: $e');
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

}
