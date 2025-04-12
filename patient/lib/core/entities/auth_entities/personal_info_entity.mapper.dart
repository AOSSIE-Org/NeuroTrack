// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'personal_info_entity.dart';

class PersonalInfoEntityMapper extends ClassMapperBase<PersonalInfoEntity> {
  PersonalInfoEntityMapper._();

  static PersonalInfoEntityMapper? _instance;
  static PersonalInfoEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PersonalInfoEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PersonalInfoEntity';

  static String _$patientId(PersonalInfoEntity v) => v.patientId;
  static const Field<PersonalInfoEntity, String> _f$patientId =
      Field('patientId', _$patientId, key: r'id');
  static String _$patientName(PersonalInfoEntity v) => v.patientName;
  static const Field<PersonalInfoEntity, String> _f$patientName =
      Field('patientName', _$patientName, key: r'patient_name');
  static int _$age(PersonalInfoEntity v) => v.age;
  static const Field<PersonalInfoEntity, int> _f$age = Field('age', _$age);
  static bool _$isAdult(PersonalInfoEntity v) => v.isAdult;
  static const Field<PersonalInfoEntity, bool> _f$isAdult =
      Field('isAdult', _$isAdult, key: r'is_adult');
  static String _$phoneNo(PersonalInfoEntity v) => v.phoneNo;
  static const Field<PersonalInfoEntity, String> _f$phoneNo =
      Field('phoneNo', _$phoneNo, key: r'phone');
  static String _$email(PersonalInfoEntity v) => v.email;
  static const Field<PersonalInfoEntity, String> _f$email =
      Field('email', _$email);
  static String? _$guardianName(PersonalInfoEntity v) => v.guardianName;
  static const Field<PersonalInfoEntity, String> _f$guardianName =
      Field('guardianName', _$guardianName, key: r'guardian_name', opt: true);
  static String? _$guardianRelation(PersonalInfoEntity v) => v.guardianRelation;
  static const Field<PersonalInfoEntity, String> _f$guardianRelation = Field(
      'guardianRelation', _$guardianRelation,
      key: r'guardian_relation', opt: true);
  static String? _$country(PersonalInfoEntity v) => v.country;
  static const Field<PersonalInfoEntity, String> _f$country =
      Field('country', _$country, opt: true);
  static String? _$gender(PersonalInfoEntity v) => v.gender;
  static const Field<PersonalInfoEntity, String> _f$gender =
      Field('gender', _$gender, opt: true);

  @override
  final MappableFields<PersonalInfoEntity> fields = const {
    #patientId: _f$patientId,
    #patientName: _f$patientName,
    #age: _f$age,
    #isAdult: _f$isAdult,
    #phoneNo: _f$phoneNo,
    #email: _f$email,
    #guardianName: _f$guardianName,
    #guardianRelation: _f$guardianRelation,
    #country: _f$country,
    #gender: _f$gender,
  };

  static PersonalInfoEntity _instantiate(DecodingData data) {
    return PersonalInfoEntity(
        patientId: data.dec(_f$patientId),
        patientName: data.dec(_f$patientName),
        age: data.dec(_f$age),
        isAdult: data.dec(_f$isAdult),
        phoneNo: data.dec(_f$phoneNo),
        email: data.dec(_f$email),
        guardianName: data.dec(_f$guardianName),
        guardianRelation: data.dec(_f$guardianRelation),
        country: data.dec(_f$country),
        gender: data.dec(_f$gender));
  }

  @override
  final Function instantiate = _instantiate;

  static PersonalInfoEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PersonalInfoEntity>(map);
  }

  static PersonalInfoEntity fromJson(String json) {
    return ensureInitialized().decodeJson<PersonalInfoEntity>(json);
  }
}

mixin PersonalInfoEntityMappable {
  String toJson() {
    return PersonalInfoEntityMapper.ensureInitialized()
        .encodeJson<PersonalInfoEntity>(this as PersonalInfoEntity);
  }

  Map<String, dynamic> toMap() {
    return PersonalInfoEntityMapper.ensureInitialized()
        .encodeMap<PersonalInfoEntity>(this as PersonalInfoEntity);
  }

  PersonalInfoEntityCopyWith<PersonalInfoEntity, PersonalInfoEntity,
          PersonalInfoEntity>
      get copyWith => _PersonalInfoEntityCopyWithImpl(
          this as PersonalInfoEntity, $identity, $identity);
  @override
  String toString() {
    return PersonalInfoEntityMapper.ensureInitialized()
        .stringifyValue(this as PersonalInfoEntity);
  }

  @override
  bool operator ==(Object other) {
    return PersonalInfoEntityMapper.ensureInitialized()
        .equalsValue(this as PersonalInfoEntity, other);
  }

  @override
  int get hashCode {
    return PersonalInfoEntityMapper.ensureInitialized()
        .hashValue(this as PersonalInfoEntity);
  }
}

extension PersonalInfoEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PersonalInfoEntity, $Out> {
  PersonalInfoEntityCopyWith<$R, PersonalInfoEntity, $Out>
      get $asPersonalInfoEntity =>
          $base.as((v, t, t2) => _PersonalInfoEntityCopyWithImpl(v, t, t2));
}

abstract class PersonalInfoEntityCopyWith<$R, $In extends PersonalInfoEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? patientId,
      String? patientName,
      int? age,
      bool? isAdult,
      String? phoneNo,
      String? email,
      String? guardianName,
      String? guardianRelation,
      String? country,
      String? gender});
  PersonalInfoEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PersonalInfoEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PersonalInfoEntity, $Out>
    implements PersonalInfoEntityCopyWith<$R, PersonalInfoEntity, $Out> {
  _PersonalInfoEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PersonalInfoEntity> $mapper =
      PersonalInfoEntityMapper.ensureInitialized();
  @override
  $R call(
          {String? patientId,
          String? patientName,
          int? age,
          bool? isAdult,
          String? phoneNo,
          String? email,
          Object? guardianName = $none,
          Object? guardianRelation = $none,
          Object? country = $none,
          Object? gender = $none}) =>
      $apply(FieldCopyWithData({
        if (patientId != null) #patientId: patientId,
        if (patientName != null) #patientName: patientName,
        if (age != null) #age: age,
        if (isAdult != null) #isAdult: isAdult,
        if (phoneNo != null) #phoneNo: phoneNo,
        if (email != null) #email: email,
        if (guardianName != $none) #guardianName: guardianName,
        if (guardianRelation != $none) #guardianRelation: guardianRelation,
        if (country != $none) #country: country,
        if (gender != $none) #gender: gender
      }));
  @override
  PersonalInfoEntity $make(CopyWithData data) => PersonalInfoEntity(
      patientId: data.get(#patientId, or: $value.patientId),
      patientName: data.get(#patientName, or: $value.patientName),
      age: data.get(#age, or: $value.age),
      isAdult: data.get(#isAdult, or: $value.isAdult),
      phoneNo: data.get(#phoneNo, or: $value.phoneNo),
      email: data.get(#email, or: $value.email),
      guardianName: data.get(#guardianName, or: $value.guardianName),
      guardianRelation:
          data.get(#guardianRelation, or: $value.guardianRelation),
      country: data.get(#country, or: $value.country),
      gender: data.get(#gender, or: $value.gender));

  @override
  PersonalInfoEntityCopyWith<$R2, PersonalInfoEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PersonalInfoEntityCopyWithImpl($value, $cast, t);
}
