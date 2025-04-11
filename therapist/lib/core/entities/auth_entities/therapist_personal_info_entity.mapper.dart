// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapist_personal_info_entity.dart';

class TherapistPersonalInfoEntityMapper
    extends ClassMapperBase<TherapistPersonalInfoEntity> {
  TherapistPersonalInfoEntityMapper._();

  static TherapistPersonalInfoEntityMapper? _instance;
  static TherapistPersonalInfoEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TherapistPersonalInfoEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapistPersonalInfoEntity';

  static String _$id(TherapistPersonalInfoEntity v) => v.id;
  static const Field<TherapistPersonalInfoEntity, String> _f$id =
      Field('id', _$id);
  static String _$name(TherapistPersonalInfoEntity v) => v.name;
  static const Field<TherapistPersonalInfoEntity, String> _f$name =
      Field('name', _$name);
  static int _$age(TherapistPersonalInfoEntity v) => v.age;
  static const Field<TherapistPersonalInfoEntity, int> _f$age =
      Field('age', _$age);
  static String _$gender(TherapistPersonalInfoEntity v) => v.gender;
  static const Field<TherapistPersonalInfoEntity, String> _f$gender =
      Field('gender', _$gender);
  static int _$professionId(TherapistPersonalInfoEntity v) => v.professionId;
  static const Field<TherapistPersonalInfoEntity, int> _f$professionId =
      Field('professionId', _$professionId, key: r'profession_id');
  static String _$professionName(TherapistPersonalInfoEntity v) =>
      v.professionName;
  static const Field<TherapistPersonalInfoEntity, String> _f$professionName =
      Field('professionName', _$professionName, key: r'profession_name');
  static String _$regulatoryBody(TherapistPersonalInfoEntity v) =>
      v.regulatoryBody;
  static const Field<TherapistPersonalInfoEntity, String> _f$regulatoryBody =
      Field('regulatoryBody', _$regulatoryBody, key: r'regulatory_body');
  static String _$licenseNumber(TherapistPersonalInfoEntity v) =>
      v.licenseNumber;
  static const Field<TherapistPersonalInfoEntity, String> _f$licenseNumber =
      Field('licenseNumber', _$licenseNumber, key: r'license_number');
  static String _$specialization(TherapistPersonalInfoEntity v) =>
      v.specialization;
  static const Field<TherapistPersonalInfoEntity, String> _f$specialization =
      Field('specialization', _$specialization, key: r'specializations');
  static List<String> _$therapies(TherapistPersonalInfoEntity v) => v.therapies;
  static const Field<TherapistPersonalInfoEntity, List<String>> _f$therapies =
      Field('therapies', _$therapies);
  static String _$startAvailabilityTime(TherapistPersonalInfoEntity v) =>
      v.startAvailabilityTime;
  static const Field<TherapistPersonalInfoEntity, String>
      _f$startAvailabilityTime = Field(
          'startAvailabilityTime', _$startAvailabilityTime,
          key: r'start_availability_time');
  static String _$endAvailabilityTime(TherapistPersonalInfoEntity v) =>
      v.endAvailabilityTime;
  static const Field<TherapistPersonalInfoEntity, String>
      _f$endAvailabilityTime = Field(
          'endAvailabilityTime', _$endAvailabilityTime,
          key: r'end_availability_time');

  @override
  final MappableFields<TherapistPersonalInfoEntity> fields = const {
    #id: _f$id,
    #name: _f$name,
    #age: _f$age,
    #gender: _f$gender,
    #professionId: _f$professionId,
    #professionName: _f$professionName,
    #regulatoryBody: _f$regulatoryBody,
    #licenseNumber: _f$licenseNumber,
    #specialization: _f$specialization,
    #therapies: _f$therapies,
    #startAvailabilityTime: _f$startAvailabilityTime,
    #endAvailabilityTime: _f$endAvailabilityTime,
  };

  static TherapistPersonalInfoEntity _instantiate(DecodingData data) {
    return TherapistPersonalInfoEntity(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        age: data.dec(_f$age),
        gender: data.dec(_f$gender),
        professionId: data.dec(_f$professionId),
        professionName: data.dec(_f$professionName),
        regulatoryBody: data.dec(_f$regulatoryBody),
        licenseNumber: data.dec(_f$licenseNumber),
        specialization: data.dec(_f$specialization),
        therapies: data.dec(_f$therapies),
        startAvailabilityTime: data.dec(_f$startAvailabilityTime),
        endAvailabilityTime: data.dec(_f$endAvailabilityTime));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapistPersonalInfoEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapistPersonalInfoEntity>(map);
  }

  static TherapistPersonalInfoEntity fromJson(String json) {
    return ensureInitialized().decodeJson<TherapistPersonalInfoEntity>(json);
  }
}

mixin TherapistPersonalInfoEntityMappable {
  String toJson() {
    return TherapistPersonalInfoEntityMapper.ensureInitialized()
        .encodeJson<TherapistPersonalInfoEntity>(
            this as TherapistPersonalInfoEntity);
  }

  Map<String, dynamic> toMap() {
    return TherapistPersonalInfoEntityMapper.ensureInitialized()
        .encodeMap<TherapistPersonalInfoEntity>(
            this as TherapistPersonalInfoEntity);
  }

  TherapistPersonalInfoEntityCopyWith<TherapistPersonalInfoEntity,
          TherapistPersonalInfoEntity, TherapistPersonalInfoEntity>
      get copyWith => _TherapistPersonalInfoEntityCopyWithImpl<
              TherapistPersonalInfoEntity, TherapistPersonalInfoEntity>(
          this as TherapistPersonalInfoEntity, $identity, $identity);
  @override
  String toString() {
    return TherapistPersonalInfoEntityMapper.ensureInitialized()
        .stringifyValue(this as TherapistPersonalInfoEntity);
  }

  @override
  bool operator ==(Object other) {
    return TherapistPersonalInfoEntityMapper.ensureInitialized()
        .equalsValue(this as TherapistPersonalInfoEntity, other);
  }

  @override
  int get hashCode {
    return TherapistPersonalInfoEntityMapper.ensureInitialized()
        .hashValue(this as TherapistPersonalInfoEntity);
  }
}

extension TherapistPersonalInfoEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapistPersonalInfoEntity, $Out> {
  TherapistPersonalInfoEntityCopyWith<$R, TherapistPersonalInfoEntity, $Out>
      get $asTherapistPersonalInfoEntity => $base.as((v, t, t2) =>
          _TherapistPersonalInfoEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TherapistPersonalInfoEntityCopyWith<
    $R,
    $In extends TherapistPersonalInfoEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get therapies;
  $R call(
      {String? id,
      String? name,
      int? age,
      String? gender,
      int? professionId,
      String? professionName,
      String? regulatoryBody,
      String? licenseNumber,
      String? specialization,
      List<String>? therapies,
      String? startAvailabilityTime,
      String? endAvailabilityTime});
  TherapistPersonalInfoEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapistPersonalInfoEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapistPersonalInfoEntity, $Out>
    implements
        TherapistPersonalInfoEntityCopyWith<$R, TherapistPersonalInfoEntity,
            $Out> {
  _TherapistPersonalInfoEntityCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapistPersonalInfoEntity> $mapper =
      TherapistPersonalInfoEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get therapies =>
      ListCopyWith($value.therapies, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(therapies: v));
  @override
  $R call(
          {String? id,
          String? name,
          int? age,
          String? gender,
          int? professionId,
          String? professionName,
          String? regulatoryBody,
          String? licenseNumber,
          String? specialization,
          List<String>? therapies,
          String? startAvailabilityTime,
          String? endAvailabilityTime}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (age != null) #age: age,
        if (gender != null) #gender: gender,
        if (professionId != null) #professionId: professionId,
        if (professionName != null) #professionName: professionName,
        if (regulatoryBody != null) #regulatoryBody: regulatoryBody,
        if (licenseNumber != null) #licenseNumber: licenseNumber,
        if (specialization != null) #specialization: specialization,
        if (therapies != null) #therapies: therapies,
        if (startAvailabilityTime != null)
          #startAvailabilityTime: startAvailabilityTime,
        if (endAvailabilityTime != null)
          #endAvailabilityTime: endAvailabilityTime
      }));
  @override
  TherapistPersonalInfoEntity $make(CopyWithData data) =>
      TherapistPersonalInfoEntity(
          id: data.get(#id, or: $value.id),
          name: data.get(#name, or: $value.name),
          age: data.get(#age, or: $value.age),
          gender: data.get(#gender, or: $value.gender),
          professionId: data.get(#professionId, or: $value.professionId),
          professionName: data.get(#professionName, or: $value.professionName),
          regulatoryBody: data.get(#regulatoryBody, or: $value.regulatoryBody),
          licenseNumber: data.get(#licenseNumber, or: $value.licenseNumber),
          specialization: data.get(#specialization, or: $value.specialization),
          therapies: data.get(#therapies, or: $value.therapies),
          startAvailabilityTime: data.get(#startAvailabilityTime,
              or: $value.startAvailabilityTime),
          endAvailabilityTime:
              data.get(#endAvailabilityTime, or: $value.endAvailabilityTime));

  @override
  TherapistPersonalInfoEntityCopyWith<$R2, TherapistPersonalInfoEntity, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TherapistPersonalInfoEntityCopyWithImpl<$R2, $Out2>(
              $value, $cast, t);
}
