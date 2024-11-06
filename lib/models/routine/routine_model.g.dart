// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoutineImpl _$$RoutineImplFromJson(Map<String, dynamic> json) =>
    _$RoutineImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      icon: json['icon'] as String,
      description: json['description'] as String?,
      alert: json['alert'] == null
          ? null
          : DateTime.parse(json['alert'] as String),
      frequency: Frequency.fromJson(json['frequency'] as Map<String, dynamic>),
      recurrence: (json['recurrence'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$RoutineImplToJson(_$RoutineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'icon': instance.icon,
      'description': instance.description,
      'alert': instance.alert?.toIso8601String(),
      'frequency': instance.frequency,
      'recurrence': instance.recurrence,
      'days': instance.days,
    };
