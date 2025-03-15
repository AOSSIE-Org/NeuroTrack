import 'package:patient/core/entities/auth_entities/auth_entities.dart';
import 'package:patient/core/repository/auth/auth_repository.dart';
import 'package:patient/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseAuthRepository implements AuthRepository {

  SupabaseAuthRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  
  final SupabaseClient _supabaseClient;

  @override
  Future<ActionResult> signInWithGoogle() {
    throw UnimplementedError();
  }

  // Method to store patient's personal information in Supbase [PATIENT] table
  @override
  Future<ActionResult> storePersonalInfo(PersonalInfoEntity personalInfoEntity) async {
    final response = await _supabaseClient.from('patient').insert({
      'id': _supabaseClient.auth.currentUser?.id,
      'patient_name': personalInfoEntity.patientName,
      'age': personalInfoEntity.age,
      'is_adult': personalInfoEntity.isAdult,
      'phone_no': personalInfoEntity.phoneNo,
      'email': personalInfoEntity.email,
      'guardian_name': personalInfoEntity.guardianName,
      'guardian_relation': personalInfoEntity.guardianRelation,
      'gender': personalInfoEntity.gender,
      'country': personalInfoEntity.country,
    });

    if (response.error != null) {
      return ActionResultFailure(
        errorMessage: response.error?.message ?? 'Some error occurred while storing personal information',
        statusCode: response.error?.code,
      );
    }

    return ActionResultSuccess(
      data: 'Personal information stored successfully',
      statusCode: 200
    );
  }

}