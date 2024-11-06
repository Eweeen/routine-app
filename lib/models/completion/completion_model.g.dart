// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompletionImpl _$$CompletionImplFromJson(Map<String, dynamic> json) =>
    _$CompletionImpl(
      id: (json['id'] as num).toInt(),
      state: State.fromJson(json['state'] as Map<String, dynamic>),
      description: json['description'] as String?,
      image: json['image'] as String?,
      routine: Routine.fromJson(json['routine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompletionImplToJson(_$CompletionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'description': instance.description,
      'image': instance.image,
      'routine': instance.routine,
    };
