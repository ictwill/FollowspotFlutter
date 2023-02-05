import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cue.g.dart';

@JsonSerializable()
class Cue {
  int id;
  double number;
  String action;
  String target;
  String size;
  int intensity;
  List<String> frames;
  int time;
  String notes;

  Cue({
    this.id = -1,
    this.number = 0.0,
    this.action = '',
    this.target = '',
    this.size = '',
    this.intensity = -1,
    this.frames = const [],
    this.time = -1,
    this.notes = '',
  });

  @override
  String toString() {
    return 'Cue $number will $action to $intensity on $target over $time seconds';
  }

  factory Cue.fromJson(Map<String, dynamic> json) => _$CueFromJson(json);

  Map<String, dynamic> toJson() => _$CueToJson(this);

  Color getColor() => Colors.amber;
}
