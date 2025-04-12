// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapy_model.dart';

class TherapyModelMapper extends ClassMapperBase<TherapyModel> {
  TherapyModelMapper._();

  static TherapyModelMapper? _instance;
  static TherapyModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapyModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapyModel';

  static String _$id(TherapyModel v) => v.id;
  static const Field<TherapyModel, String> _f$id = Field('id', _$id);
  static String _$name(TherapyModel v) => v.name;
  static const Field<TherapyModel, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<TherapyModel> fields = const {
    #id: _f$id,
    #name: _f$name,
  };

  static TherapyModel _instantiate(DecodingData data) {
    return TherapyModel(id: data.dec(_f$id), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapyModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapyModel>(map);
  }

  static TherapyModel fromJson(String json) {
    return ensureInitialized().decodeJson<TherapyModel>(json);
  }
}

mixin TherapyModelMappable {
  String toJson() {
    return TherapyModelMapper.ensureInitialized()
        .encodeJson<TherapyModel>(this as TherapyModel);
  }

  Map<String, dynamic> toMap() {
    return TherapyModelMapper.ensureInitialized()
        .encodeMap<TherapyModel>(this as TherapyModel);
  }

  TherapyModelCopyWith<TherapyModel, TherapyModel, TherapyModel> get copyWith =>
      _TherapyModelCopyWithImpl(this as TherapyModel, $identity, $identity);
  @override
  String toString() {
    return TherapyModelMapper.ensureInitialized()
        .stringifyValue(this as TherapyModel);
  }

  @override
  bool operator ==(Object other) {
    return TherapyModelMapper.ensureInitialized()
        .equalsValue(this as TherapyModel, other);
  }

  @override
  int get hashCode {
    return TherapyModelMapper.ensureInitialized()
        .hashValue(this as TherapyModel);
  }
}

extension TherapyModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapyModel, $Out> {
  TherapyModelCopyWith<$R, TherapyModel, $Out> get $asTherapyModel =>
      $base.as((v, t, t2) => _TherapyModelCopyWithImpl(v, t, t2));
}

abstract class TherapyModelCopyWith<$R, $In extends TherapyModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  TherapyModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TherapyModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapyModel, $Out>
    implements TherapyModelCopyWith<$R, TherapyModel, $Out> {
  _TherapyModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapyModel> $mapper =
      TherapyModelMapper.ensureInitialized();
  @override
  $R call({String? id, String? name}) => $apply(FieldCopyWithData(
      {if (id != null) #id: id, if (name != null) #name: name}));
  @override
  TherapyModel $make(CopyWithData data) => TherapyModel(
      id: data.get(#id, or: $value.id), name: data.get(#name, or: $value.name));

  @override
  TherapyModelCopyWith<$R2, TherapyModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapyModelCopyWithImpl($value, $cast, t);
}
