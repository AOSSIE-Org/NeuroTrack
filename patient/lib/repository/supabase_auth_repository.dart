import 'package:patient/core/entities/auth_entities/auth_entities.dart';
import 'package:patient/core/repository/auth/auth_repository.dart';
import 'package:patient/core/result/result.dart';
import 'package:patient/model/auth_models/auth_model.dart';
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
  Future<ActionResult> storePersonalInfo(
      PersonalInfoEntity personalInfoEntity) async {
    try {
      final patientId = _supabaseClient.auth.currentSession?.user.id;
      await _supabaseClient
          .from('patient')
          .insert(personalInfoEntity.copyWith(patientId: patientId).toMap());

      return ActionResultSuccess(
          data: 'Personal information stored successfully', statusCode: 200);
    } catch (e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

  @override
  Future<ActionResult> checkIfPatientExists() async {
    try {
      final response = await _supabaseClient
          .from('patient')
          .select('*')
          .eq('id', _supabaseClient.auth.currentUser!.id)
          .maybeSingle();

      if (response != null) {
        return ActionResultSuccess(data: true, statusCode: 200);
      } else {
        return ActionResultSuccess(data: false, statusCode: 400);
      }
    } catch (e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

  @override
  Future<ActionResult> getAllAvailableTherapist() async {
    try {
      final response = await _supabaseClient
          .from('therapist')
          .select('*')
          .eq('approved', true);

      if (response.isNotEmpty) {
        final therapistData = response
            .map((e) => TherapistEntityMapper.fromMap(e).toModel())
            .toList();
        return ActionResultSuccess(data: therapistData, statusCode: 200);
      } else {
        return ActionResultSuccess(data: <TherapistModel>[], statusCode: 200);
      }
    } catch (e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

  @override
  Future<ActionResult> getAvailableBookingSlotsForTherapist(
    String therapistId,
    DateTime date,
    String startTimeOfTherapist,
    String endTimeOfTherapist,
  ) async {
    try {
      // Format: '2025-04-12'
      final DateTime startOfDay =
          DateTime(date.year, date.month, date.day, 0, 0, 0);
      final DateTime endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59);

      final response = await _supabaseClient
          .from('session')
          .select('timestamp')
          .eq('therapist_id', therapistId)
          .eq('status', 'accepted')
          .gte('timestamp', startOfDay.toUtc().toIso8601String())
          .lte('timestamp', endOfDay.toUtc().toIso8601String());

      final bookedTimestamps =
          (response as List).map((e) => DateTime.parse(e['timestamp']).toLocal()).toSet();

      final startHourOfTherapist =
          int.parse(startTimeOfTherapist.split(':')[0]);
      final startMinuteOfTherapist =
          int.parse(startTimeOfTherapist.split(':')[1]);
      final endHourOfTherapist = int.parse(endTimeOfTherapist.split(':')[0]);
      final endMinuteOfTherapist = int.parse(endTimeOfTherapist.split(':')[1]);

      DateTime slotStart = DateTime(date.year, date.month, date.day,
          startHourOfTherapist, startMinuteOfTherapist);
      DateTime slotEnd = DateTime(date.year, date.month, date.day,
          endHourOfTherapist, endMinuteOfTherapist);

      final List<String> availableSlots = [];

      while (slotStart.isBefore(slotEnd)) {
        final isBooked = bookedTimestamps.any((booked) =>
            booked.hour == slotStart.hour && booked.minute == slotStart.minute);

        if (!isBooked) {
          availableSlots.add(_formatTime(slotStart));
        }

        slotStart = slotStart.add(const Duration(minutes: 30));
      }

      return ActionResultSuccess(data: availableSlots, statusCode: 200);
    } catch (e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }


  @override
  Future<ActionResult> bookConsultation(
      ConsultationRequestEntity consultationRequestEntity) async {
    try {
       final response = await _supabaseClient.from('patient')
          .select('therapist_id')
          .eq('id', _supabaseClient.auth.currentUser!.id)
          .maybeSingle();
      final updateConsultationRequestEntity =
          consultationRequestEntity.copyWith(
       patientId: _supabaseClient.auth.currentUser!.id,
       therapistId: response?['therapist_id'] ?? '',
        mode: 1,
        status: 'pending',
      );
      
      await _supabaseClient
          .from('session')
          .insert(
            updateConsultationRequestEntity.toMap(),
          );

      return ActionResultSuccess(
        data: 'Consultation booked successfully', statusCode: 200);
    } catch (e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  
  @override
  Future<ActionResult> checkIfPatientAssessmentExists() async {
    try {
      final response = await _supabaseClient.from('assessment_results')
          .select('*')
          .eq('patient_id', _supabaseClient.auth.currentUser!.id);

      if(response.isEmpty) {
        return ActionResultSuccess(data: false, statusCode: 200);
      } else {
        return ActionResultSuccess(data: true, statusCode: 200);
      }
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }
  
  @override
  Future<ActionResult> checkIfPatientConsultationExists() async {
    try {
      final response = await _supabaseClient.from('session')
          .select('*')
          .eq('patient_id', _supabaseClient.auth.currentUser!.id);
      if(response.isEmpty) {
        return ActionResultSuccess(data: false, statusCode: 200);
      } else {
        return ActionResultSuccess(data: true, statusCode: 200);
      }
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 400,
      );
    }
  }

}
