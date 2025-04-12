import 'package:therapist/core/core.dart';

abstract interface class TherapyRepository {

  /// Get all therapy types
  /// 
  /// Returns a list of therapy types
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful

  Future<ActionResult> getTherapyTypes();

  /// Add therapy goals
  /// 
  /// Returns a message if the operation is successful
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful

  Future<ActionResult> addTherapyGoals(String therapyTypeId, String goal);

  /// Add therapy observations
  /// 
  /// Returns a message if the operation is successful
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful

  Future<ActionResult> addTherapyObservations(String therapyTypeId, String observation);

  /// Add therapy regressions
  /// 
  /// Returns a message if the operation is successful
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful
  
  Future<ActionResult> addTherapyRegressions(String therapyTypeId, String regression);

  /// Add therapy activities
  /// 
  /// Returns a message if the operation is successful
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful
  
  Future<ActionResult> addTherapyActivities(String therapyTypeId, String activity);

  /// Get all therapy goals
  /// 
  /// Returns a list of therapy goals
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful

  Future<ActionResult> getAllGoals(String therapyTypeId);

  /// Get all therapy observations
  /// 
  /// Returns a list of therapy observations
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful
  
  Future<ActionResult> getAllObservations(String therapyTypeId);

  /// Get all therapy regressions
  /// 
  /// Returns a list of therapy regressions
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful
  
  Future<ActionResult> getAllRegressions(String therapyTypeId);

  /// Get all therapy activities
  /// 
  /// Returns a list of therapy activities
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful
  
  Future<ActionResult> getAllActivities(String therapyTypeId);

  /// Save therapy goals
  /// 
  /// Returns a message if the operation is successful
  /// 
  /// Throws an [ActionResultFailure] if an exception occurs
  /// 
  /// Returns an [ActionResultSuccess] if the operation is successful
  
  Future<ActionResult> saveTherapyGoals(TherapyGoalEntity therapyGoalEntity);
}