

import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/model/auth_models/personal_info_model.dart';

part 'personal_info_entity.mapper.dart';

// Entity class to store patient's personal information to Supabase [PATIENT] table
// This class can have toModel and fromModel methods to convert to and from model

@MappableClass()
class PersonalInfoEntity with PersonalInfoEntityMappable {

  @MappableField(key: 'patient_id')
  final String patientId;

  @MappableField(key: 'patient_name')
  final String patientName;

  @MappableField(key: 'age')
  final int age;

  @MappableField(key: 'is_adult')
  final bool isAdult;

  @MappableField(key: 'phone_no')
  final String phoneNo;

  @MappableField(key: 'email')
  final String email;

  @MappableField(key: 'guardian_name')
  final String? guardianName;

  @MappableField(key: 'guardian_relation')
  final String? guardianRelation;

  @MappableField(key: 'gender')
  final String? gender;
  
  @MappableField(key: 'country')
  final String? country;


  PersonalInfoEntity({
    required this.patientId,
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

  PersonalInfoModel toModel() {
    return PersonalInfoModel(
      patientId: patientId,
      patientName: patientName,
      age: age,
      isAdult: isAdult,
      phoneNo: phoneNo,
      email: email,
      guardianName: guardianName ?? '',
      guardianRelation: guardianRelation ?? '',
      country: country ?? '',
      gender: gender ?? '',
    );
  }

}