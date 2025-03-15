import 'package:patient/core/entities/auth_entities/personal_info_entity.dart';
import 'package:patient/core/result/result.dart';

abstract interface class AuthRepository {
  // The abstract repository class will define the methods that the repository must implement.
  
  // Method to sign in with Google with [SUPABASE] as a provider
  Future<ActionResult> signInWithGoogle();

  // Method to store patient's personal information
  Future<ActionResult> storePersonalInfo(PersonalInfoEntity personalInfoEntity);
}
