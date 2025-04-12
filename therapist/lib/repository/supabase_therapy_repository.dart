import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:therapist/core/entities/therapy_entities/therapy_entities.dart';
import 'package:therapist/core/entities/therapy_entities/therapy_type_entity.dart';
import 'package:therapist/core/result/result.dart';
import 'package:therapist/model/therapy_models/therapy_models.dart';

import '../core/repository/repository.dart';

class SupabaseTherapyRepository implements TherapyRepository {
  final _supabaseClient = Supabase.instance.client;

  @override
  Future<ActionResult> getTherapyTypes() async {
    try {
      final response = await _supabaseClient.from('therapy_type').select('*');
      final data = response
          .map((e) => TherapyTypeEntityMapper.fromMap(e).toModel())
          .toList();
      return ActionResultSuccess(data: data, statusCode: 200);
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ActionResult> addTherapyActivities(
      String therapyTypeId, String activity) async {
    try {
      final response = await _supabaseClient
          .from('activity_master')
          .select()
          .eq('activity_text', activity)
          .maybeSingle();

      if (response != null) {
        List<String> existingTherapies =
            List<String>.from(response['applicable_therapies']);

        if (!existingTherapies.contains(therapyTypeId)) {
          existingTherapies.add(therapyTypeId);

          await _supabaseClient.from('activity_master').update({
            'applicable_therapies': existingTherapies,
          }).eq('id', response['id']);
        }
      } else {
        await _supabaseClient.from('activity_master').insert({
          'activity_text': activity,
          'applicable_therapies': [therapyTypeId],
        });
      }

      return ActionResultSuccess(
          data: 'Activity Added Successfully', statusCode: 200);
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ActionResult> addTherapyGoals(
      String therapyTypeId, String goal) async {
    try {
      final response = await _supabaseClient
          .from('goal_master')
          .select()
          .eq('goal_text', goal)
          .maybeSingle();

      if (response != null) {
        List<String> existingTherapies =
            List<String>.from(response['applicable_therapies']);

        if (!existingTherapies.contains(therapyTypeId)) {
          existingTherapies.add(therapyTypeId);

          await _supabaseClient.from('goal_master').update({
            'applicable_therapies': existingTherapies,
          }).eq('id', response['id']);
        }
      } else {
        await _supabaseClient.from('goal_master').insert({
          'goal_text': goal,
          'applicable_therapies': [therapyTypeId],
        });
      }

      return ActionResultSuccess(
          data: 'Goal Added Successfully', statusCode: 200);
    } catch (error) {
      return ActionResultFailure(
          errorMessage: error.toString(), statusCode: 500);
    }
  }

  @override
  Future<ActionResult> addTherapyObservations(
      String therapyTypeId, String observation) async {
    try {
      final response = await _supabaseClient
          .from('observation_master')
          .select()
          .eq('observation_text', observation)
          .maybeSingle();

      if (response != null) {
        List<String> existingTherapies =
            List<String>.from(response['applicable_therapies']);

        if (!existingTherapies.contains(therapyTypeId)) {
          existingTherapies.add(therapyTypeId);

          await _supabaseClient.from('observation_master').update({
            'applicable_therapies': existingTherapies,
          }).eq('id', response['id']);
        }
      } else {
        await _supabaseClient.from('observation_master').insert({
          'observation_text': observation,
          'applicable_therapies': [therapyTypeId],
        });
      }

      return ActionResultSuccess(
          data: 'Observation Added Successfully', statusCode: 200);
    } catch (error) {
      return ActionResultFailure(
          errorMessage: error.toString(), statusCode: 500);
    }
  }

  @override
  Future<ActionResult> addTherapyRegressions(
      String therapyTypeId, String regression) async {
    try {
      final response = await _supabaseClient
          .from('regression_master')
          .select()
          .eq('regression_text', regression)
          .maybeSingle();

      if (response != null) {
        List<String> existingTherapies =
            List<String>.from(response['applicable_therapies']);

        if (!existingTherapies.contains(therapyTypeId)) {
          existingTherapies.add(therapyTypeId);

          await _supabaseClient.from('regression_master').update({
            'applicable_therapies': existingTherapies,
          }).eq('id', response['id']);
        }
      } else {
        await _supabaseClient.from('regression_master').insert({
          'regression_text': regression,
          'applicable_therapies': [therapyTypeId],
        });
      }

      return ActionResultSuccess(
          data: 'Regression Added Successfully', statusCode: 200);
    } catch (error) {
      return ActionResultFailure(
          errorMessage: error.toString(), statusCode: 500);
    }
  }
  
  @override
  Future<ActionResult> getAllActivities(String therapyTypeId) async {
    try {
      final response = await _supabaseClient
          .from('activity_master')
          .select('id, activity_text',)
          .contains('applicable_therapies', [therapyTypeId]);
      
      if(response.isNotEmpty) {
        final data = response.map((e) => TherapyEntity(id: e['id'], name: e['activity_text']) ).toList();
        return ActionResultSuccess(data: data.map((e) => e.toModel()).toList(), statusCode: 200);
      } else {
        return ActionResultSuccess(data: <TherapyModel>[], statusCode: 200);
      }
    } catch(e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
  
  @override
  Future<ActionResult> getAllGoals(String therapyTypeId) async {
    try {
      final response = await _supabaseClient
          .from('goal_master')
          .select('id, goal_text',)
          .contains('applicable_therapies', [therapyTypeId]);
      
      if(response.isNotEmpty) {
        final data = response.map((e) => TherapyEntity(id: e['id'], name: e['goal_text']) ).toList();
        return ActionResultSuccess(data: data.map((e) => e.toModel()).toList(), statusCode: 200);
      } else {
        return ActionResultSuccess(data: <TherapyModel>[], statusCode: 200);
      }
    } catch (e)  {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
  
  @override
  Future<ActionResult> getAllObservations(String therapyTypeId) async {
    try {
      final response = await _supabaseClient
          .from('observation_master')
          .select('id, observation_text',)
          .contains('applicable_therapies', [therapyTypeId]);
      
      if(response.isNotEmpty) {
        final data = response.map((e) => TherapyEntity(id: e['id'], name: e['observation_text']) ).toList();
        return ActionResultSuccess(data: data.map((e) => e.toModel()).toList(), statusCode: 200);
      } else {
        return ActionResultSuccess(data: <TherapyModel>[], statusCode: 200);
      }
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
  
  @override
  Future<ActionResult> getAllRegressions(String therapyTypeId) async {
    try {
      final response = await _supabaseClient
          .from('regression_master')
          .select('id, regression_text',)
          .contains('applicable_therapies', [therapyTypeId]);
      
      if(response.isNotEmpty) {
        final data = response.map((e) => TherapyEntity(id: e['id'], name: e['regression_text']) ).toList();
        return ActionResultSuccess(data: data.map((e) => e.toModel()).toList(), statusCode: 200);
      } else {
        return ActionResultSuccess(data: <TherapyModel>[], statusCode: 200);
      }
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
  
  @override
  Future<ActionResult> saveTherapyGoals(TherapyGoalEntity therapyGoalEntity) async {
    try {
      await _supabaseClient.from('therapy_goal')
        .insert(therapyGoalEntity.copyWith(therapistId: _supabaseClient.auth.currentUser!.id).toMap());
      return ActionResultSuccess(data: 'Therapy Goal Saved Successfully', statusCode: 200);
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
}
