import 'package:therapist/core/result/action_result.dart';
import 'package:therapist/core/models/profession_model.dart';

abstract interface class TherapistRepository {

  /// Retrieves the list of patients associated with the therapist from the `patients` table.
  /// 
  /// This method fetches the list of patients associated with the therapist from the `patients` table
  /// using Supabase.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a list of [TherapistPatientDetailsEntity] and status code `200` if the
  /// patients are successfully fetched.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  ///
  /// - **Exceptions:**
  /// - If an error occurs while fetching the records, it is caught and returned as a failure.

  Future<ActionResult> getTherapistPatients();

  /// Retrieves the schedule of the therapist from the `session` table.
  /// 
  /// This method fetches the schedule of the therapist from the
  /// `session` table using Supabase.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a list of [TherapistScheduleEntity] and status code `200` if the
  /// schedule is successfully fetched.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  /// 
  /// - **Exceptions:**
  /// - If an error occurs while fetching the records, it is caught and returned as a failure.

  Future<ActionResult> getTherapistSchedule();

  /// Retrieves the upcoming appointments of the therapist from the `session` table.
  /// 
  /// This method fetches the upcoming appointments of the therapist from the
  /// `session` table using Supabase.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a list of [TherapistUpcomingAppointmentEntity] and status code `200` if the
  /// appointments are successfully fetched.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  /// 
  /// - **Exceptions:**
  /// - If an error occurs while fetching the records, it is caught and returned as a failure.
  
  Future<ActionResult> getTherapistUpcomingAppointments();

  /// Changes the status of an appointment in the `session` table.
  /// 
  /// This method takes an `appointmentId` and a `status` as parameters and updates the status
  /// of the appointment in the `session` table using Supabase.
  /// 
  /// - **Parameters:**
  ///  - `appointmentId` : The unique identifier of the appointment.
  /// - `status` : The new status of the appointment.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a success message and status code `200` if the appointment
  /// status is successfully updated.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  /// 
  /// - **Exceptions:**
  /// - If an error occurs while updating the record, it is caught and returned as a failure.

  Future<ActionResult> changeAppointmentStatus(String appointmentId, String status);


  // TODO: Add the following methods
  // HOW do we differentiate between therapy and session?
  
  Future<ActionResult> getTotalPatients();

  // Get the total number of Sessions

  Future<ActionResult> getTotalSessions();

  // Get the total number of Therapies

  Future<ActionResult> getTotalTherapies();

  // New methods for fetching profession data
  Future<ActionResult> fetchProfessions();
  Future<ActionResult> fetchRegulatoryBodies(int professionId);
  Future<ActionResult> fetchSpecializations(int professionId);
  Future<ActionResult> fetchTherapies(int professionId);
}