import 'package:dart_mappable/dart_mappable.dart';
import 'package:therapist/core/core.dart';
import 'package:therapist/model/therapy_models/therapy_model.dart';

part 'therapy_goal_model.mapper.dart';

@MappableClass()
class TherapyGoalModel with TherapyGoalModelMappable {

  @MappableField(key: 'performed_on')
  final DateTime performedOn;

  @MappableField(key: 'therapist_id')
  final String? therapistId;

  @MappableField(key: 'therapy_type_id')
  final String therapyTypeId;

  @MappableField(key: 'goals')
  final List<TherapyModel> goals;

  @MappableField(key: 'observations')
  final List<TherapyModel> observations;

  @MappableField(key: 'regressions')
  final List<TherapyModel> regressions;

  @MappableField(key: 'activities')
  final List<TherapyModel> activities;


  TherapyGoalModel({
    required this.performedOn,
    this.therapistId,
    required this.therapyTypeId,
    required this.goals,
    required this.observations,
    required this.regressions,
    required this.activities,
  });

  TherapyGoalEntity toEntity() {
    return TherapyGoalEntity(
      performedOn: performedOn,
      therapyTypeId: therapyTypeId,
      goals: goals,
      observations: observations,
      regressions: regressions,
      activities: activities,
    );
  }
}