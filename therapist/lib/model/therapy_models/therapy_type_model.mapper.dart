// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapy_type_model.dart';

class TherapyTypeModelMapper extends ClassMapperBase<TherapyTypeModel> {
  TherapyTypeModelMapper._();

  static TherapyTypeModelMapper? _instance;
  static TherapyTypeModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapyTypeModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapyTypeModel';

  static String _$therapyId(TherapyTypeModel v) => v.therapyId;
  static const Field<TherapyTypeModel, String> _f$therapyId =
      Field('therapyId', _$therapyId, key: r'id');
  static DateTime _$createdAt(TherapyTypeModel v) => v.createdAt;
  static const Field<TherapyTypeModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$name(TherapyTypeModel v) => v.name;
  static const Field<TherapyTypeModel, String> _f$name = Field('name', _$name);
  static String _$description(TherapyTypeModel v) => v.description;
  static const Field<TherapyTypeModel, String> _f$description =
      Field('description', _$description);

  @override
  final MappableFields<TherapyTypeModel> fields = const {
    #therapyId: _f$therapyId,
    #createdAt: _f$createdAt,
    #name: _f$name,
    #description: _f$description,
  };

  static TherapyTypeModel _instantiate(DecodingData data) {
    return TherapyTypeModel(
        therapyId: data.dec(_f$therapyId),
        createdAt: data.dec(_f$createdAt),
        name: data.dec(_f$name),
        description: data.dec(_f$description));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapyTypeModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapyTypeModel>(map);
  }

  static TherapyTypeModel fromJson(String json) {
    return ensureInitialized().decodeJson<TherapyTypeModel>(json);
  }
}

mixin TherapyTypeModelMappable {
  String toJson() {
    return TherapyTypeModelMapper.ensureInitialized()
        .encodeJson<TherapyTypeModel>(this as TherapyTypeModel);
  }

  Map<String, dynamic> toMap() {
    return TherapyTypeModelMapper.ensureInitialized()
        .encodeMap<TherapyTypeModel>(this as TherapyTypeModel);
  }

  TherapyTypeModelCopyWith<TherapyTypeModel, TherapyTypeModel, TherapyTypeModel>
      get copyWith => _TherapyTypeModelCopyWithImpl(
          this as TherapyTypeModel, $identity, $identity);
  @override
  String toString() {
    return TherapyTypeModelMapper.ensureInitialized()
        .stringifyValue(this as TherapyTypeModel);
  }

  @override
  bool operator ==(Object other) {
    return TherapyTypeModelMapper.ensureInitialized()
        .equalsValue(this as TherapyTypeModel, other);
  }

  @override
  int get hashCode {
    return TherapyTypeModelMapper.ensureInitialized()
        .hashValue(this as TherapyTypeModel);
  }
}

extension TherapyTypeModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapyTypeModel, $Out> {
  TherapyTypeModelCopyWith<$R, TherapyTypeModel, $Out>
      get $asTherapyTypeModel =>
          $base.as((v, t, t2) => _TherapyTypeModelCopyWithImpl(v, t, t2));
}

abstract class TherapyTypeModelCopyWith<$R, $In extends TherapyTypeModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? therapyId,
      DateTime? createdAt,
      String? name,
      String? description});
  TherapyTypeModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapyTypeModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapyTypeModel, $Out>
    implements TherapyTypeModelCopyWith<$R, TherapyTypeModel, $Out> {
  _TherapyTypeModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapyTypeModel> $mapper =
      TherapyTypeModelMapper.ensureInitialized();
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
  TherapyTypeModel $make(CopyWithData data) => TherapyTypeModel(
      therapyId: data.get(#therapyId, or: $value.therapyId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      name: data.get(#name, or: $value.name),
      description: data.get(#description, or: $value.description));

  @override
  TherapyTypeModelCopyWith<$R2, TherapyTypeModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapyTypeModelCopyWithImpl($value, $cast, t);
}
