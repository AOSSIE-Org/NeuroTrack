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
      // Validate that all questions have been answered
      if (answers.questions.isEmpty) {
        return ActionResultFailure(
          errorMessage: 'Please answer all questions before submitting',
          statusCode: 400,
        );
      }

      // Check for unanswered questions
      final unansweredQuestions =
          answers.questions.where((q) => q.answerId.isEmpty).toList();
      if (unansweredQuestions.isNotEmpty) {
        return ActionResultFailure(
          errorMessage: 'Please answer all questions before submitting',
          statusCode: 400,
        );
      }

      final jwtToken = dotenv.env['SUPABASE_ANON_KEY']!;
      final response = await _supabase.functions.invoke(
        'evaluate-assessments',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: answers.toMap(),
      );

      if (response.data != null) {
        final data = AssessmentResultEntityMapper.fromMap(response.data);
        return ActionResultSuccess(data: data.toModel(), statusCode: 200);
      } else {
        return ActionResultFailure(
          errorMessage: 'Failed to evaluate assessment. Please try again.',
          statusCode: 400,
        );
      }
    } catch (e) {
      if (e.toString().contains('NetworkError')) {
        return ActionResultFailure(
          errorMessage: 'Network error. Please check your internet connection.',
          statusCode: 500,
        );
      } else if (e.toString().contains('401')) {
        return ActionResultFailure(
          errorMessage: 'Authentication error. Please log in again.',
          statusCode: 401,
        );
      } else if (e.toString().contains('404')) {
        return ActionResultFailure(
          errorMessage:
              'Server error: Assessment evaluation service is not available. Please try again later.',
          statusCode: 404,
        );
      } else {
        return ActionResultFailure(
          errorMessage: 'An unexpected error occurred: ${e.toString()}',
          statusCode: 500,
        );
      }
    }
  }
}
