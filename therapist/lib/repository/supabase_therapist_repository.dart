import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:therapist/core/entities/therapist_entities/therapist_patient_details_entity.dart';
import 'package:therapist/core/entities/therapist_entities/therapist_schedule_entity.dart';
import 'package:therapist/core/entities/therapist_entities/therapist_upcoming_appointment_entity.dart';
import 'package:therapist/core/models/profession_model.dart';

import '../core/repository/repository.dart';
import '../core/result/result.dart';

class SupabaseTherapistRepository implements TherapistRepository {

  SupabaseTherapistRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Future<ActionResult> changeAppointmentStatus(String appointmentId, String status) async {
    try {
      await _supabaseClient.from('session')
      .update({'status': status})
      .eq('id', appointmentId);
  
     return ActionResultSuccess(data: 'Appointment Update Successfully', statusCode: 200);
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
    }
  }

  @override
  Future<ActionResult> getTherapistPatients() async {
   try {
      final response = await _supabaseClient.from('patients')
      .select('*')
      .eq('therapist_id', _supabaseClient.auth.currentUser!.id);
    
      final data = response.map((data) => TherapistPatientDetailsEntityMapper.fromMap(data)).toList();

      return ActionResultSuccess(data: data, statusCode: 200); 
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
   } 
  }

  @override
  Future<ActionResult> getTherapistSchedule() async {
   try {
      final response = await _supabaseClient.from('session')
      .select('*')
      .eq('therapist_id', _supabaseClient.auth.currentUser!.id);
    
      final data = response.map((data) => TherapistScheduleEntityMapper.fromMap(data)).toList();

      return ActionResultSuccess(data: data, statusCode: 200); 
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
   }
  }

  @override
  Future<ActionResult> getTherapistUpcomingAppointments() async {
    try {
       final response = await _supabaseClient.from('session')
      .select('*')
      .eq('therapist_id', _supabaseClient.auth.currentUser!.id)
      .eq('status', 'Pending');
    
      final data = response.map((data) => TherapistUpcomingAppointmentEntityMapper.fromMap(data)).toList();

      return ActionResultSuccess(data: data, statusCode: 200); 
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
    }
  }
  
  @override
  Future<ActionResult> getTotalPatients() {
    // TODO: implement getTotalPatients
    throw UnimplementedError();
  }
  
  @override
  Future<ActionResult> getTotalSessions() {
    // TODO: implement getTotalSessions
    throw UnimplementedError();
  }
  
  @override
  Future<ActionResult> getTotalTherapies() {
    // TODO: implement getTotalTherapies
    throw UnimplementedError();
  }

  @override
  Future<ActionResult> fetchProfessions() async {
    try {
      final response = await _supabaseClient.from('profession').select('*');
      
      final data = response.map((item) => ProfessionModel.fromMap(item)).toList();
      
      return ActionResultSuccess(data: data, statusCode: 200);
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
    }
  }
@override
Future<ActionResult> fetchRegulatoryBodies(int professionId) async {
  try {
    final response = await _supabaseClient
        .from('profession_details')
        .select('id, profession_id, regulatory_body')
        .eq('profession_id', professionId);
    
    // Transform data after retrieving it
    final Set<String> uniqueBodies = {};
    List<RegulatoryBodyModel> data = [];
    
    for (var item in response) {
      final body = item['regulatory_body'] as String;
      if (!uniqueBodies.contains(body)) {
        uniqueBodies.add(body);
        data.add(RegulatoryBodyModel.fromMap({
          'id': item['id'],
          'profession_id': item['profession_id'],
          'name': body,
        }));
      }
    }
    
    return ActionResultSuccess(data: data, statusCode: 200);
  } catch (e) {
    print('Error fetching regulatory bodies: $e');
    return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
  }
}

@override
Future<ActionResult> fetchSpecializations(int professionId) async {
  try {
    final response = await _supabaseClient
        .from('profession_details')
        .select('id, profession_id, specialization')
        .eq('profession_id', professionId);
    
    // Transform data after retrieving it
    final Set<String> uniqueSpecs = {};
    List<SpecializationModel> data = [];
    
    for (var item in response) {
      final spec = item['specialization'] as String;
      if (!uniqueSpecs.contains(spec)) {
        uniqueSpecs.add(spec);
        data.add(SpecializationModel.fromMap({
          'id': item['id'],
          'profession_id': item['profession_id'],
          'name': spec,
        }));
      }
    }
    
    return ActionResultSuccess(data: data, statusCode: 200);
  } catch (e) {
    print('Error fetching specializations: $e');
    return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
  }
}

@override
Future<ActionResult> fetchTherapies(int professionId) async {
  try {
    final response = await _supabaseClient
        .from('profession_details')
        .select('id, profession_id, therapy_offered')
        .eq('profession_id', professionId);
    
    // Transform data after retrieving it
    final Set<String> uniqueTherapies = {};
    List<TherapyModel> data = [];
    
    for (var item in response) {
      final therapy = item['therapy_offered'] as String;
      if (!uniqueTherapies.contains(therapy)) {
        uniqueTherapies.add(therapy);
        data.add(TherapyModel.fromMap({
          'id': item['id'],
          'profession_id': item['profession_id'],
          'name': therapy,
        }));
      }
    }
    
    return ActionResultSuccess(data: data, statusCode: 200);
  } catch (e) {
    print('Error fetching therapies: $e');
    return ActionResultFailure(errorMessage: e.toString(), statusCode: 400);
  }
}
}