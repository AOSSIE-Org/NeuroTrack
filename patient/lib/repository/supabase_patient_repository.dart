import 'package:patient/core/result/result.dart';
import 'package:patient/presentation/appointments/models/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/entities/entities.dart';
import '../core/repository/repository.dart';
import '../model/task_model.dart';
import '../model/therapy_models/therapy_models.dart';

class SupabasePatientRepository implements PatientRepository {

  SupabasePatientRepository({
    required SupabaseClient supabaseClient
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Future<ActionResult> scheduleAppointment(PatientScheduleAppointmentEntity appointmentEntity) async {  
    try {
      await _supabaseClient.from('session')
      .insert(appointmentEntity.toMap());
      return ActionResultSuccess(
        data: 'Appointment scheduled successfully',
        statusCode: 200
      );
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 500
      );
    }
  }
  
  @override
  Future<ActionResult> getTherapyGoals({required DateTime date}) async {
    try {
      final response = await _supabaseClient.from('therapy_goal')
      .select('*')
      .eq('patient_id', _supabaseClient.auth.currentUser!.id);

      if (response.isEmpty) {
        return ActionResultFailure(
          errorMessage: 'No therapy goals found',
          statusCode: 404
        );
      }

      // Filter the results by date
      final filteredResponse = response.where((goal) {
        final goalDate = DateTime.parse(goal['performed_on']);
        return goalDate.year == date.year && 
               goalDate.month == date.month && 
               goalDate.day == date.day;
      }).toList();

      if (filteredResponse.isEmpty) {
        return ActionResultFailure(
          errorMessage: 'No therapy goals found for the specified date',
          statusCode: 404
        );
      }

      final therapist = await _supabaseClient.from('therapist')
      .select('*')
      .eq('id', filteredResponse.first['therapist_id']).maybeSingle();

      final therapyType = await _supabaseClient.from('therapy_type')
      .select('*')
      .eq('id', filteredResponse.first['therapy_type_id']).maybeSingle();

      final therapyGoal = TherapyGoalModelMapper.fromMap(filteredResponse.first);

      return ActionResultSuccess(data: therapyGoal.copyWith(
        therapistName: therapist?['name'],
        therapistPhone: therapist?['phone'],
        therapistEmail: therapist?['email'],
        therapyType: therapyType?['name'],
        therapyMode: filteredResponse.first['therapy_mode'],
        specialization: therapist?['specialisation']
      ), statusCode: 200);
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 500
      );
    }
  }

  @override
  Future<ActionResult> fetchAllAppointments() async {
    try {
      final response = await _supabaseClient.from('session').select('*').eq('patient_id', _supabaseClient.auth.currentUser!.id);
       if (response.isEmpty) {
        return ActionResultFailure(
          errorMessage: 'No consultation requests found',
          statusCode: 404
        );
      }
      final data = response as List<dynamic>;

      final consultationData = data.map((session) {
        return AppointmentModel(
          id: session['id'],
          serviceType: session['is_consultation'] ? 'Consultation' : 'Therapy Session',
          appointmentDate: DateTime.parse(session['timestamp']),
          timeSlot: session['timestamp'],
          isCompleted: DateTime.parse(session['timestamp']).isBefore(DateTime.now())
        );
      }).toList();

      return ActionResultSuccess(data: consultationData, statusCode: 200);
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 500
      );
    }
  }

  @override
  Future<ActionResult> deleteAppointment(String id) async {
    try {
      await _supabaseClient.from('session').delete().eq('id', id);
      return ActionResultSuccess(
        data: 'Appointment deleted successfully',
        statusCode: 200
      );
    } catch(e) {
      return ActionResultFailure(
        errorMessage: e.toString(),
        statusCode: 500
      );
    }
  }

  @override
  Future<ActionResult> getTodayActivities({DateTime? date}) async {
    try {
      // TODO: Refactor this part when developing the therapist part of the same feature.
      final dateTime = date ?? DateTime.now();
      final response = await _supabaseClient.from('daily_activity')
      .select('*')
      .eq('patient_id', _supabaseClient.auth.currentUser!.id)
      .eq('date', dateTime.toIso8601String());
      
      if (response.isEmpty) {
        return ActionResultFailure(errorMessage: 'No activities found', statusCode: 404);
      }
      return ActionResultSuccess(data: response, statusCode: 200);
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ActionResult> updateActivityCompletion(List<PatientTaskModel> tasks) async {
    try {
      // Refactor this part when developing the therapist part of the same feature.
      for(int i=0;i<tasks.length;i++) {
        await _supabaseClient.from('daily_activity')
        .update({'is_completed': tasks[i].isCompleted}).eq('id', tasks[i].activityId ?? '')
        .eq('patient_id', _supabaseClient.auth.currentUser!.id);
      }

      return ActionResultSuccess(data: 'Activity updated successfully', statusCode: 200);
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
}
