

import 'package:dart_mappable/dart_mappable.dart';

part 'personal_info_entity.mapper.dart';

@MappableClass()
class PersonalInfoEntity with PersonalInfoEntityMappable {

  final String patientName;
  final int age;
  final bool isAdult;
  final String phoneNo;
  final String email;
  final String? guardianName;
  final String? guardianRelation;
  final String? gender;
  final String? country;


  PersonalInfoEntity({
    required this.patientName,
    required this.age,
    required this.isAdult,
    required this.phoneNo,
    required this.email,
    this.guardianName,
    this.guardianRelation,
    this.country,
    this.gender,
  });
}