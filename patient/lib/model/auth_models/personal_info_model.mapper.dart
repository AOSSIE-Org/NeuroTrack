// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'personal_info_model.dart';

class PersonalInfoModelMapper extends ClassMapperBase<PersonalInfoModel> {
  PersonalInfoModelMapper._();

  static PersonalInfoModelMapper? _instance;
  static PersonalInfoModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PersonalInfoModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PersonalInfoModel';

  static String _$patientName(PersonalInfoModel v) => v.patientName;
  static const Field<PersonalInfoModel, String> _f$patientName =
      Field('patientName', _$patientName);
  static int _$age(PersonalInfoModel v) => v.age;
  static const Field<PersonalInfoModel, int> _f$age = Field('age', _$age);
  static bool _$isAdult(PersonalInfoModel v) => v.isAdult;
  static const Field<PersonalInfoModel, bool> _f$isAdult =
      Field('isAdult', _$isAdult);
  static String _$phoneNo(PersonalInfoModel v) => v.phoneNo;
  static const Field<PersonalInfoModel, String> _f$phoneNo =
      Field('phoneNo', _$phoneNo);
  static String _$email(PersonalInfoModel v) => v.email;
  static const Field<PersonalInfoModel, String> _f$email =
      Field('email', _$email);
  static String _$guardianName(PersonalInfoModel v) => v.guardianName;
  static const Field<PersonalInfoModel, String> _f$guardianName =
      Field('guardianName', _$guardianName);
  static String _$guardianRelation(PersonalInfoModel v) => v.guardianRelation;
  static const Field<PersonalInfoModel, String> _f$guardianRelation =
      Field('guardianRelation', _$guardianRelation);
  static String _$country(PersonalInfoModel v) => v.country;
  static const Field<PersonalInfoModel, String> _f$country =
      Field('country', _$country);
  static String _$gender(PersonalInfoModel v) => v.gender;
  static const Field<PersonalInfoModel, String> _f$gender =
      Field('gender', _$gender);

  @override
  final MappableFields<PersonalInfoModel> fields = const {
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

  static PersonalInfoModel _instantiate(DecodingData data) {
    return PersonalInfoModel(
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

  static PersonalInfoModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PersonalInfoModel>(map);
  }

  static PersonalInfoModel fromJson(String json) {
    return ensureInitialized().decodeJson<PersonalInfoModel>(json);
  }
}

mixin PersonalInfoModelMappable {
  String toJson() {
    return PersonalInfoModelMapper.ensureInitialized()
        .encodeJson<PersonalInfoModel>(this as PersonalInfoModel);
  }

  Map<String, dynamic> toMap() {
    return PersonalInfoModelMapper.ensureInitialized()
        .encodeMap<PersonalInfoModel>(this as PersonalInfoModel);
  }

  PersonalInfoModelCopyWith<PersonalInfoModel, PersonalInfoModel,
          PersonalInfoModel>
      get copyWith => _PersonalInfoModelCopyWithImpl(
          this as PersonalInfoModel, $identity, $identity);
  @override
  String toString() {
    return PersonalInfoModelMapper.ensureInitialized()
        .stringifyValue(this as PersonalInfoModel);
  }

  @override
  bool operator ==(Object other) {
    return PersonalInfoModelMapper.ensureInitialized()
        .equalsValue(this as PersonalInfoModel, other);
  }

  @override
  int get hashCode {
    return PersonalInfoModelMapper.ensureInitialized()
        .hashValue(this as PersonalInfoModel);
  }
}

extension PersonalInfoModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PersonalInfoModel, $Out> {
  PersonalInfoModelCopyWith<$R, PersonalInfoModel, $Out>
      get $asPersonalInfoModel =>
          $base.as((v, t, t2) => _PersonalInfoModelCopyWithImpl(v, t, t2));
}

abstract class PersonalInfoModelCopyWith<$R, $In extends PersonalInfoModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? patientName,
      int? age,
      bool? isAdult,
      String? phoneNo,
      String? email,
      String? guardianName,
      String? guardianRelation,
      String? country,
      String? gender});
  PersonalInfoModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PersonalInfoModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PersonalInfoModel, $Out>
    implements PersonalInfoModelCopyWith<$R, PersonalInfoModel, $Out> {
  _PersonalInfoModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PersonalInfoModel> $mapper =
      PersonalInfoModelMapper.ensureInitialized();
  @override
  $R call(
          {String? patientName,
          int? age,
          bool? isAdult,
          String? phoneNo,
          String? email,
          String? guardianName,
          String? guardianRelation,
          String? country,
          String? gender}) =>
      $apply(FieldCopyWithData({
        if (patientName != null) #patientName: patientName,
        if (age != null) #age: age,
        if (isAdult != null) #isAdult: isAdult,
        if (phoneNo != null) #phoneNo: phoneNo,
        if (email != null) #email: email,
        if (guardianName != null) #guardianName: guardianName,
        if (guardianRelation != null) #guardianRelation: guardianRelation,
        if (country != null) #country: country,
        if (gender != null) #gender: gender
      }));
  @override
  PersonalInfoModel $make(CopyWithData data) => PersonalInfoModel(
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
  PersonalInfoModelCopyWith<$R2, PersonalInfoModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PersonalInfoModelCopyWithImpl($value, $cast, t);
}
