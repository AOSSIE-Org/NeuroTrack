import 'package:patient/core/core.dart';

abstract interface class AuthRepository {
  // The abstract repository class will define the methods that the repository must implement.
  
  // Method to sign in with Google with [SUPABASE] as a provider
  Future<ActionResult> signInWithGoogle();

  /// Stores the personal information of the patient in the `patient` table.
  /// 
  /// This method takes a [PersonalInfoEntity] object, converts it to a map,
  /// and inserts it into the `patient` table using Supabase.
  /// 
  /// - **Parameters:**
  ///  - `personalInfoEntity` : An instance of [PersonalInfoEntity] containing
  ///   personal information of the patient.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  ///  - [ActionResultSuccess] with a success message and status code `200` if the personal
  ///  information is successfully stored.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  /// 
  /// - **Exceptions:**
  /// - If an error occurs while inserting the record, it is caught and returned as a failure.
  
  Future<ActionResult> storePersonalInfo(PersonalInfoEntity personalInfoEntity);

  /// Checks if the patient already exists in the `patient` table.
  /// 
  /// This method checks if the patient already exists in the `patient` table
  /// using the `patient_id` from the [PersonalInfoEntity].
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a success message and status code `200` if the patient
  /// exists in the `patient` table.
  /// - [ActionResultFailure] with an error message and status code `400` if the patient
  /// does not exist in the `patient` table.
  /// 
  /// - **Exceptions:**
  /// - If an error occurs while checking if the patient exists, it is caught and returned as a failure.

  Future<ActionResult> checkIfPatientExists();

  /// Fetches all available therapists from the `therapist` table.
  ///   
  /// This method retrieves all available therapists from the `therapist` table
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a success message and status code `200` if the therapists
  /// are successfully fetched.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  Future<ActionResult> getAllAvailableTherapist(); 

  /// Fetches all available booking slots for a specific therapist on a given date.
  ///  
  /// This method retrieves all available booking slots for a specific therapist
  /// on a given date.
  /// 
  /// - **Parameters:**
  /// - `therapistId` : The ID of the therapist for whom the booking slots are to be fetched.
  /// - `date` : The date for which the booking slots are to be fetched.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a success message and status code `200` if the booking slots
  /// are successfully fetched.
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  ///   
  Future<ActionResult> getAvailableBookingSlotsForTherapist(
    String therapistId,
    DateTime date,
    String startTimeOfTherapist,
    String endTimeOfTherapist,
  );

  /// Books a consultation for the patient with the therapist.
  /// 
  /// This method books a consultation for the patient with the therapist
  /// using the provided [ConsultationRequestEntity].
  /// 
  /// - **Parameters:**
  /// - `consultationRequestEntity` : An instance of [ConsultationRequestEntity] containing
  /// 
  /// the details of the consultation request.
  /// 
  /// - **Returns:**
  /// - A [Future] of [ActionResult], which can either be:
  /// - [ActionResultSuccess] with a success message and status code `200` if the consultation
  /// is successfully booked.
  /// 
  /// - [ActionResultFailure] with an error message and status code `400` if an exception occurs.
  /// 

  Future<ActionResult> bookConsultation(ConsultationRequestEntity consultationRequestEntity);


  Future<ActionResult> checkIfPatientAssessmentExists();

  Future<ActionResult> checkIfPatientConsultationExists();

}
