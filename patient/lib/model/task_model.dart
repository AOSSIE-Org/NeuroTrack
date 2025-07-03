import 'package:dart_mappable/dart_mappable.dart';

part 'task_model.mapper.dart';

@MappableClass()
class PatientTaskModel with PatientTaskModelMappable {
  @MappableField(key: 'activity_id')
  final String? activityId;
  @MappableField(key: 'activity_name')
  final String? activityName;
  @MappableField(key: 'is_completed')
  final bool? isCompleted;

  PatientTaskModel({
    this.activityId,
    this.activityName,
    this.isCompleted = false,
  });

  static const fromMap = PatientTaskModelMapper.fromMap;
  static const fromJson = PatientTaskModelMapper.fromJson;

}
