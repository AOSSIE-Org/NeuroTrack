// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapy_goal_entity.dart';

class TherapyGoalEntityMapper extends ClassMapperBase<TherapyGoalEntity> {
  TherapyGoalEntityMapper._();

  static TherapyGoalEntityMapper? _instance;
  static TherapyGoalEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapyGoalEntityMapper._());
      TherapyModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TherapyGoalEntity';

  static DateTime _$performedOn(TherapyGoalEntity v) => v.performedOn;
  static const Field<TherapyGoalEntity, DateTime> _f$performedOn =
      Field('performedOn', _$performedOn, key: r'performed_on');
  static String? _$therapistId(TherapyGoalEntity v) => v.therapistId;
  static const Field<TherapyGoalEntity, String> _f$therapistId =
      Field('therapistId', _$therapistId, key: r'therapist_id', opt: true);
  static String _$therapyTypeId(TherapyGoalEntity v) => v.therapyTypeId;
  static const Field<TherapyGoalEntity, String> _f$therapyTypeId =
      Field('therapyTypeId', _$therapyTypeId, key: r'therapy_type_id');
  static List<TherapyModel> _$goals(TherapyGoalEntity v) => v.goals;
  static const Field<TherapyGoalEntity, List<TherapyModel>> _f$goals =
      Field('goals', _$goals);
  static List<TherapyModel> _$observations(TherapyGoalEntity v) =>
      v.observations;
  static const Field<TherapyGoalEntity, List<TherapyModel>> _f$observations =
      Field('observations', _$observations);
  static List<TherapyModel> _$regressions(TherapyGoalEntity v) => v.regressions;
  static const Field<TherapyGoalEntity, List<TherapyModel>> _f$regressions =
      Field('regressions', _$regressions);
  static List<TherapyModel> _$activities(TherapyGoalEntity v) => v.activities;
  static const Field<TherapyGoalEntity, List<TherapyModel>> _f$activities =
      Field('activities', _$activities);

  @override
  final MappableFields<TherapyGoalEntity> fields = const {
    #performedOn: _f$performedOn,
    #therapistId: _f$therapistId,
    #therapyTypeId: _f$therapyTypeId,
    #goals: _f$goals,
    #observations: _f$observations,
    #regressions: _f$regressions,
    #activities: _f$activities,
  };

  static TherapyGoalEntity _instantiate(DecodingData data) {
    return TherapyGoalEntity(
        performedOn: data.dec(_f$performedOn),
        therapistId: data.dec(_f$therapistId),
        therapyTypeId: data.dec(_f$therapyTypeId),
        goals: data.dec(_f$goals),
        observations: data.dec(_f$observations),
        regressions: data.dec(_f$regressions),
        activities: data.dec(_f$activities));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapyGoalEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapyGoalEntity>(map);
  }

  static TherapyGoalEntity fromJson(String json) {
    return ensureInitialized().decodeJson<TherapyGoalEntity>(json);
  }
}

mixin TherapyGoalEntityMappable {
  String toJson() {
    return TherapyGoalEntityMapper.ensureInitialized()
        .encodeJson<TherapyGoalEntity>(this as TherapyGoalEntity);
  }

  Map<String, dynamic> toMap() {
    return TherapyGoalEntityMapper.ensureInitialized()
        .encodeMap<TherapyGoalEntity>(this as TherapyGoalEntity);
  }

  TherapyGoalEntityCopyWith<TherapyGoalEntity, TherapyGoalEntity,
          TherapyGoalEntity>
      get copyWith => _TherapyGoalEntityCopyWithImpl(
          this as TherapyGoalEntity, $identity, $identity);
  @override
  String toString() {
    return TherapyGoalEntityMapper.ensureInitialized()
        .stringifyValue(this as TherapyGoalEntity);
  }

  @override
  bool operator ==(Object other) {
    return TherapyGoalEntityMapper.ensureInitialized()
        .equalsValue(this as TherapyGoalEntity, other);
  }

  @override
  int get hashCode {
    return TherapyGoalEntityMapper.ensureInitialized()
        .hashValue(this as TherapyGoalEntity);
  }
}

extension TherapyGoalEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapyGoalEntity, $Out> {
  TherapyGoalEntityCopyWith<$R, TherapyGoalEntity, $Out>
      get $asTherapyGoalEntity =>
          $base.as((v, t, t2) => _TherapyGoalEntityCopyWithImpl(v, t, t2));
}

abstract class TherapyGoalEntityCopyWith<$R, $In extends TherapyGoalEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get goals;
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get observations;
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get regressions;
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get activities;
  $R call(
      {DateTime? performedOn,
      String? therapistId,
      String? therapyTypeId,
      List<TherapyModel>? goals,
      List<TherapyModel>? observations,
      List<TherapyModel>? regressions,
      List<TherapyModel>? activities});
  TherapyGoalEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapyGoalEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapyGoalEntity, $Out>
    implements TherapyGoalEntityCopyWith<$R, TherapyGoalEntity, $Out> {
  _TherapyGoalEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapyGoalEntity> $mapper =
      TherapyGoalEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get goals => ListCopyWith(
          $value.goals, (v, t) => v.copyWith.$chain(t), (v) => call(goals: v));
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get observations => ListCopyWith($value.observations,
          (v, t) => v.copyWith.$chain(t), (v) => call(observations: v));
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get regressions => ListCopyWith($value.regressions,
          (v, t) => v.copyWith.$chain(t), (v) => call(regressions: v));
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get activities => ListCopyWith($value.activities,
          (v, t) => v.copyWith.$chain(t), (v) => call(activities: v));
  @override
  $R call(
          {DateTime? performedOn,
          Object? therapistId = $none,
          String? therapyTypeId,
          List<TherapyModel>? goals,
          List<TherapyModel>? observations,
          List<TherapyModel>? regressions,
          List<TherapyModel>? activities}) =>
      $apply(FieldCopyWithData({
        if (performedOn != null) #performedOn: performedOn,
        if (therapistId != $none) #therapistId: therapistId,
        if (therapyTypeId != null) #therapyTypeId: therapyTypeId,
        if (goals != null) #goals: goals,
        if (observations != null) #observations: observations,
        if (regressions != null) #regressions: regressions,
        if (activities != null) #activities: activities
      }));
  @override
  TherapyGoalEntity $make(CopyWithData data) => TherapyGoalEntity(
      performedOn: data.get(#performedOn, or: $value.performedOn),
      therapistId: data.get(#therapistId, or: $value.therapistId),
      therapyTypeId: data.get(#therapyTypeId, or: $value.therapyTypeId),
      goals: data.get(#goals, or: $value.goals),
      observations: data.get(#observations, or: $value.observations),
      regressions: data.get(#regressions, or: $value.regressions),
      activities: data.get(#activities, or: $value.activities));

  @override
  TherapyGoalEntityCopyWith<$R2, TherapyGoalEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapyGoalEntityCopyWithImpl($value, $cast, t);
}
