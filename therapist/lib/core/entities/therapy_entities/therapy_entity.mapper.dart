// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapy_entity.dart';

class TherapyEntityMapper extends ClassMapperBase<TherapyEntity> {
  TherapyEntityMapper._();

  static TherapyEntityMapper? _instance;
  static TherapyEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapyEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapyEntity';

  static String _$id(TherapyEntity v) => v.id;
  static const Field<TherapyEntity, String> _f$id = Field('id', _$id);
  static String _$name(TherapyEntity v) => v.name;
  static const Field<TherapyEntity, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<TherapyEntity> fields = const {
    #id: _f$id,
    #name: _f$name,
  };

  static TherapyEntity _instantiate(DecodingData data) {
    return TherapyEntity(id: data.dec(_f$id), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapyEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapyEntity>(map);
  }

  static TherapyEntity fromJson(String json) {
    return ensureInitialized().decodeJson<TherapyEntity>(json);
  }
}

mixin TherapyEntityMappable {
  String toJson() {
    return TherapyEntityMapper.ensureInitialized()
        .encodeJson<TherapyEntity>(this as TherapyEntity);
  }

  Map<String, dynamic> toMap() {
    return TherapyEntityMapper.ensureInitialized()
        .encodeMap<TherapyEntity>(this as TherapyEntity);
  }

  TherapyEntityCopyWith<TherapyEntity, TherapyEntity, TherapyEntity>
      get copyWith => _TherapyEntityCopyWithImpl(
          this as TherapyEntity, $identity, $identity);
  @override
  String toString() {
    return TherapyEntityMapper.ensureInitialized()
        .stringifyValue(this as TherapyEntity);
  }

  @override
  bool operator ==(Object other) {
    return TherapyEntityMapper.ensureInitialized()
        .equalsValue(this as TherapyEntity, other);
  }

  @override
  int get hashCode {
    return TherapyEntityMapper.ensureInitialized()
        .hashValue(this as TherapyEntity);
  }
}

extension TherapyEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapyEntity, $Out> {
  TherapyEntityCopyWith<$R, TherapyEntity, $Out> get $asTherapyEntity =>
      $base.as((v, t, t2) => _TherapyEntityCopyWithImpl(v, t, t2));
}

abstract class TherapyEntityCopyWith<$R, $In extends TherapyEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  TherapyEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TherapyEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapyEntity, $Out>
    implements TherapyEntityCopyWith<$R, TherapyEntity, $Out> {
  _TherapyEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapyEntity> $mapper =
      TherapyEntityMapper.ensureInitialized();
  @override
  $R call({String? id, String? name}) => $apply(FieldCopyWithData(
      {if (id != null) #id: id, if (name != null) #name: name}));
  @override
  TherapyEntity $make(CopyWithData data) => TherapyEntity(
      id: data.get(#id, or: $value.id), name: data.get(#name, or: $value.name));

  @override
  TherapyEntityCopyWith<$R2, TherapyEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapyEntityCopyWithImpl($value, $cast, t);
}
