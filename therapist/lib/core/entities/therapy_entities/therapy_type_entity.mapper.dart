// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapy_type_entity.dart';

class TherapyTypeEntityMapper extends ClassMapperBase<TherapyTypeEntity> {
  TherapyTypeEntityMapper._();

  static TherapyTypeEntityMapper? _instance;
  static TherapyTypeEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapyTypeEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapyTypeEntity';

  static String _$therapyId(TherapyTypeEntity v) => v.therapyId;
  static const Field<TherapyTypeEntity, String> _f$therapyId =
      Field('therapyId', _$therapyId, key: r'id');
  static DateTime _$createdAt(TherapyTypeEntity v) => v.createdAt;
  static const Field<TherapyTypeEntity, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$name(TherapyTypeEntity v) => v.name;
  static const Field<TherapyTypeEntity, String> _f$name = Field('name', _$name);
  static String _$description(TherapyTypeEntity v) => v.description;
  static const Field<TherapyTypeEntity, String> _f$description =
      Field('description', _$description);

  @override
  final MappableFields<TherapyTypeEntity> fields = const {
    #therapyId: _f$therapyId,
    #createdAt: _f$createdAt,
    #name: _f$name,
    #description: _f$description,
  };

  static TherapyTypeEntity _instantiate(DecodingData data) {
    return TherapyTypeEntity(
        therapyId: data.dec(_f$therapyId),
        createdAt: data.dec(_f$createdAt),
        name: data.dec(_f$name),
        description: data.dec(_f$description));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapyTypeEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapyTypeEntity>(map);
  }

  static TherapyTypeEntity fromJson(String json) {
    return ensureInitialized().decodeJson<TherapyTypeEntity>(json);
  }
}

mixin TherapyTypeEntityMappable {
  String toJson() {
    return TherapyTypeEntityMapper.ensureInitialized()
        .encodeJson<TherapyTypeEntity>(this as TherapyTypeEntity);
  }

  Map<String, dynamic> toMap() {
    return TherapyTypeEntityMapper.ensureInitialized()
        .encodeMap<TherapyTypeEntity>(this as TherapyTypeEntity);
  }

  TherapyTypeEntityCopyWith<TherapyTypeEntity, TherapyTypeEntity,
          TherapyTypeEntity>
      get copyWith => _TherapyTypeEntityCopyWithImpl(
          this as TherapyTypeEntity, $identity, $identity);
  @override
  String toString() {
    return TherapyTypeEntityMapper.ensureInitialized()
        .stringifyValue(this as TherapyTypeEntity);
  }

  @override
  bool operator ==(Object other) {
    return TherapyTypeEntityMapper.ensureInitialized()
        .equalsValue(this as TherapyTypeEntity, other);
  }

  @override
  int get hashCode {
    return TherapyTypeEntityMapper.ensureInitialized()
        .hashValue(this as TherapyTypeEntity);
  }
}

extension TherapyTypeEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapyTypeEntity, $Out> {
  TherapyTypeEntityCopyWith<$R, TherapyTypeEntity, $Out>
      get $asTherapyTypeEntity =>
          $base.as((v, t, t2) => _TherapyTypeEntityCopyWithImpl(v, t, t2));
}

abstract class TherapyTypeEntityCopyWith<$R, $In extends TherapyTypeEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? therapyId,
      DateTime? createdAt,
      String? name,
      String? description});
  TherapyTypeEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapyTypeEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapyTypeEntity, $Out>
    implements TherapyTypeEntityCopyWith<$R, TherapyTypeEntity, $Out> {
  _TherapyTypeEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapyTypeEntity> $mapper =
      TherapyTypeEntityMapper.ensureInitialized();
  @override
  $R call(
          {String? therapyId,
          DateTime? createdAt,
          String? name,
          String? description}) =>
      $apply(FieldCopyWithData({
        if (therapyId != null) #therapyId: therapyId,
        if (createdAt != null) #createdAt: createdAt,
        if (name != null) #name: name,
        if (description != null) #description: description
      }));
  @override
  TherapyTypeEntity $make(CopyWithData data) => TherapyTypeEntity(
      therapyId: data.get(#therapyId, or: $value.therapyId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      name: data.get(#name, or: $value.name),
      description: data.get(#description, or: $value.description));

  @override
  TherapyTypeEntityCopyWith<$R2, TherapyTypeEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapyTypeEntityCopyWithImpl($value, $cast, t);
}
