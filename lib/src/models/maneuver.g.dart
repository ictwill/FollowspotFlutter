// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maneuver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Maneuver _$ManeuverFromJson(Map<String, dynamic> json) => Maneuver(
      name: json['name'] as String,
      color: json['color'] as int? ?? 0xAA777777,
      iconPath: json['iconPath'] as String? ?? '',
      header: json['header'] as bool? ?? false,
    );

Map<String, dynamic> _$ManeuverToJson(Maneuver instance) => <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'iconPath': instance.iconPath,
      'header': instance.header,
    };
