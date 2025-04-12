import 'package:therapist/core/entities/auth_entities/therapist_personal_info_entity.dart';
import 'package:therapist/core/result/action_result.dart';

abstract interface class AuthRepository {

  Future<ActionResult> signInWithGoogle();

  /// Stores the personal information of the therapist in the `therapist` table.
  /// 
  /// This method takes a [TherapistPersonalInfoEntity] object, converts it to a map,
  /// and inserts it into the `therapist` table using Supabase.
  /// 
  /// - **Parameters:**
  /// - `personalInfoEntity` : An instance of [TherapistPersonalInfoEntity] containing
  /// personal information of the therapist.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a success message and status code `200` if the personal
  /// information is successfully stored.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  /// 
  /// - **Exceptions:**
  /// - If an error occurs while inserting the record, it is caught and returned as a failure.

  Future<ActionResult> storePersonalInfo(TherapistPersonalInfoEntity personalInfoEntity);
  Future<String?> getUserId();
  
  // Add this new method
  Future<ActionResult> checkIfUserIsNew(String userId);
  
}
