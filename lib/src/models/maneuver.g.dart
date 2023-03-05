// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maneuver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Maneuver _$ManeuverFromJson(Map<String, dynamic> json) => Maneuver(
      name: json['name'] as String,
      color: json['color'] as int? ?? 0xFF777777,
      iconName: json['iconName'] as String? ?? '',
      iconCodePoint: json['iconCodePoint'] as int?,
      header: json['header'] as bool? ?? false,
      fontFamily: json['fontFamily'] as String? ?? 'material',
    );

Map<String, dynamic> _$ManeuverToJson(Maneuver instance) => <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'iconName': instance.iconName,
      'iconCodePoint': instance.iconCodePoint,
      'header': instance.header,
      'fontFamily': instance.fontFamily,
    };
