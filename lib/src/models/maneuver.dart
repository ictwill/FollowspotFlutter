import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'maneuver.g.dart';

@JsonSerializable()
class Maneuver {
  String name;
  int color;
  int? iconCodePoint;
  bool header;
  String? fontFamily;

  // IconData iconData;

  Maneuver({
    required this.name,
    this.color = 0xFF777777,
    this.iconCodePoint,
    this.header = false,
    this.fontFamily = 'material',
  });

  @override
  bool operator ==(Object other) {
    if (other is Maneuver) {
      return name.toLowerCase() == other.name.toLowerCase();
    } else {
      return false;
    }
  }

  @override
  int get hashCode => name.hashCode;

  factory Maneuver.fromJson(Map<String, dynamic> json) =>
      _$ManeuverFromJson(json);

  Map<String, dynamic> toJson() => _$ManeuverToJson(this);

  Color getColor() => Color(color);

  void updateColor(Color value) => color = value.value;

  Color getContrastingTextColor() {
    Color background = Color(color);
    // Calculate the luminance of the background color
    final double backgroundLuminance = (0.2126 * background.red +
            0.7152 * background.green +
            0.0722 * background.blue) /
        255;

    // Choose either black or white as the contrasting color
    return backgroundLuminance > 0.5 ? Colors.black : Colors.white;
  }
}
