import 'package:dart_mappable/dart_mappable.dart';
import 'package:therapist/model/therapy_models/therapy_model.dart';


part 'therapy_entity.mapper.dart';

@MappableClass()
class TherapyEntity with TherapyEntityMappable {

  final String id;

  final String name;

  TherapyEntity({
    required this.id,
    required this.name,
  });

  TherapyModel toModel() {
    return TherapyModel(
      id: id,
      name: name,
    );
  }

}