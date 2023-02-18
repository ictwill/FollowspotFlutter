// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Spot _$SpotFromJson(Map<String, dynamic> json) => Spot(
      id: json['id'] as int,
      number: json['number'] as int,
      frames:
          (json['frames'] as List<dynamic>).map((e) => e as String).toList(),
      cues: (json['cues'] as List<dynamic>)
          .map((e) => Cue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpotToJson(Spot instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'frames': instance.frames,
      'cues': instance.cues.map((e) => e.toJson()).toList(),
    };
