import 'package:dart_mappable/dart_mappable.dart';

part 'therapist_personal_info_entity.mapper.dart';

@MappableClass()
class TherapistPersonalInfoEntity with TherapistPersonalInfoEntityMappable {
  final String id;
  @MappableField(key: 'name')
  final String name;
  @MappableField(key: 'age')
  final int age;
  @MappableField(key: 'gender')
  final String gender;
  @MappableField(key: 'profession_id')
  final int professionId;
  @MappableField(key: 'profession_name')
  final String professionName;
  @MappableField(key: 'regulatory_body')
  final String regulatoryBody;
  @MappableField(key: 'license_number')
  final String licenseNumber;
  @MappableField(key: 'specializations')
  final String specialization;
  @MappableField(key: 'therapies')
  final List<String> therapies;

  const TherapistPersonalInfoEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.professionId,
    required this.professionName,
    required this.regulatoryBody,
    required this.licenseNumber,
    required this.specialization,
    required this.therapies,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'profession_id': professionId,
      'profession_name': professionName,
      'regulatory_body': regulatoryBody,
      'license_number': licenseNumber,
      'specialization': specialization,
      'therapies': therapies,
    };
  }
}
