// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cue _$CueFromJson(Map<String, dynamic> json) => Cue(
      id: json['id'] as int? ?? -1,
      number: (json['number'] as num?)?.toDouble() ?? 0.0,
      action: json['action'] as String? ?? '',
      target: json['target'] as String? ?? '',
      time: json['time'] as int? ?? -1,
      size: json['size'] as String? ?? '',
      intensity: json['intensity'] as int? ?? -1,
      frames: (json['frames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$CueToJson(Cue instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'action': instance.action,
      'target': instance.target,
      'time': instance.time,
      'size': instance.size,
      'intensity': instance.intensity,
      'frames': instance.frames,
      'notes': instance.notes,
    };
