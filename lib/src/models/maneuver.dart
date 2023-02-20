import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'maneuver.g.dart';

@JsonSerializable()
class Maneuver {
  String name;
  int color;
  String iconPath;
  bool header;
  IconData? icon;

  Maneuver(
      {required this.name,
      this.color = 0xFF777777,
      this.iconPath = '',
      this.header = false,
      this.icon});

  factory Maneuver.fromJson(Map<String, dynamic> json) =>
      _$ManeuverFromJson(json);

  Map<String, dynamic> toJson() => _$ManeuverToJson(this);

  Color getColor() => Color(color);

  void updateColor(Color value) => color = value.value;
}
