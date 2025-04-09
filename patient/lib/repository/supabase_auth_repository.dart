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
  
  @override
  Future<ActionResult> storePersonalInfo(PersonalInfoEntity personalInfoEntity) async {
    try {
      final patientId = _supabaseClient.auth.currentSession?.user.id;
      await _supabaseClient.from('patient')
        .insert(personalInfoEntity.copyWith(patientId: patientId).toMap());

      return ActionResultSuccess(
        data: 'Personal information stored successfully',
        statusCode: 200
      );
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }
  
  @override
  Future<ActionResult> checkIfPatientExists() async {
    try {
      final response = await _supabaseClient.from('patient')
        .select('*')
        .eq('patient_id', _supabaseClient.auth.currentUser!.id)
        .maybeSingle();
      
      if(response != null) {
        return ActionResultSuccess(
          data: true,
          statusCode: 200
        );
      } else {
        return ActionResultSuccess(
          data: false,
          statusCode: 400
        );
      }
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

}
