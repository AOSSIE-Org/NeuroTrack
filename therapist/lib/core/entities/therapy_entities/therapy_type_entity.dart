
import 'package:dart_mappable/dart_mappable.dart';
import 'package:therapist/model/therapy_models/therapy_models.dart';

part 'therapy_type_entity.mapper.dart';

@MappableClass()
class TherapyTypeEntity with TherapyTypeEntityMappable {

  @MappableField(key: 'id')
  final String therapyId;

  @MappableField(key: 'created_at')
  final DateTime createdAt;

  @MappableField(key: 'name')
  final String name;

  @MappableField(key: 'description')
  final String description;

  TherapyTypeEntity({
    required this.therapyId,
    required this.createdAt,
    required this.name,
    required this.description,
  });

  TherapyTypeModel toModel() {
    return TherapyTypeModel(
      therapyId: therapyId,
      createdAt: createdAt,
      name: name,
      description: description,
    );
  }

} 