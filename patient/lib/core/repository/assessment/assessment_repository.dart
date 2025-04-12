import 'package:patient/core/entities/assessment_entities/assessment_answer_entity.dart';
import 'package:patient/core/result/action_result.dart';

abstract interface class AssessmentsRepository {
  // The abstract repository class will define the methods that the repository must implement.
  Future<List<Map<String, dynamic>>> fetchAssessmentById(String id);
  Future<ActionResult> submitAssessment(AssessmentAnswerEntity answers);

  Future<ActionResult> fetchAllAssessments();
}
