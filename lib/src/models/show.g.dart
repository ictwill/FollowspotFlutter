// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Show _$ShowFromJson(Map<String, dynamic> json) => Show(
      filename: json['filename'] as String?,
      id: json['id'] as int? ?? -1,
      info: ShowInfo.fromJson(json['info'] as Map<String, dynamic>),
      spotList: (json['spotList'] as List<dynamic>?)
              ?.map((e) => Spot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Spot>[],
      maneuverList: (json['maneuverList'] as List<dynamic>?)
              ?.map((e) => Maneuver.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Maneuver>[],
    );

Map<String, dynamic> _$ShowToJson(Show instance) => <String, dynamic>{
      'filename': instance.filename,
      'id': instance.id,
      'info': instance.info.toJson(),
      'spotList': instance.spotList.map((e) => e.toJson()).toList(),
      'maneuverList': instance.maneuverList.map((e) => e.toJson()).toList(),
    };

ShowInfo _$ShowInfoFromJson(Map<String, dynamic> json) => ShowInfo(
      id: json['id'] as int? ?? -1,
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      ld: json['ld'] as String? ?? '',
      ald: json['ald'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ShowInfoToJson(ShowInfo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'ld': instance.ld,
      'ald': instance.ald,
      'date': instance.date.toIso8601String(),
    };
