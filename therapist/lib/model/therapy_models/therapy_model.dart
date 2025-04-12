import 'package:dart_mappable/dart_mappable.dart';
import 'package:therapist/core/core.dart';

part 'therapy_model.mapper.dart';

@MappableClass()
class TherapyModel with TherapyModelMappable {

  final String id;

  final String name;

  TherapyModel({
    required this.id,
    required this.name,
  });

  TherapyEntity toEntity() {
    return TherapyEntity(
      id: id,
      name: name,
    );
  }

}