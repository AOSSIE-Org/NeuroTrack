import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:patient/core/entities/assessment_entities/assessment_answer_entity.dart';
import 'package:patient/core/entities/assessment_entities/assessment_entity.dart';
import 'package:patient/core/entities/assessment_entities/assessment_result_entity.dart'
    show AssessmentResultEntityMapper;
import 'package:patient/core/repository/assessment/assessment_repository.dart';
import 'package:patient/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAssessmentsRepository implements AssessmentsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> fetchAssessmentById(String id) async {
    print('Fetching assessment with id: $id');
    final response = await _supabase
        .from('assessments')
        .select('*')
        .eq('id', id)
        .limit(1)
        .maybeSingle();
print('Response: $response');
    return response != null ? [response] : [];
  }

  @override
  Future<ActionResult> fetchAllAssessments() async {
    try {
      final response = await _supabase.from('assessments').select('*');
      final data =
          response.map((e) => AssessmentEntityMapper.fromMap(e)).toList();
      return ActionResultSuccess(
          data: data.map((e) => e.toModel()).toList(), statusCode: 200);
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ActionResult> submitAssessment(AssessmentAnswerEntity answers) async {
    try {
      final jwtToken = dotenv.env['SUPABASE_ANON_KEY']!;
      final resposne = await _supabase.functions.invoke(
        'evaluate-assessments',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: answers.toMap(),
      );
      if (resposne.data != null) {
        final data = AssessmentResultEntityMapper.fromMap(resposne.data);
        return ActionResultSuccess(data: data.toModel(), statusCode: 200);
      } else {
        return ActionResultFailure(
            errorMessage: 'Some error Occurred', statusCode: 400);
      }
    } catch (e) {
      return ActionResultFailure(errorMessage: e.toString(), statusCode: 500);
    }
  }
}
