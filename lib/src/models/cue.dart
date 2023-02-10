import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cue.g.dart';

@JsonSerializable()
class Cue {
  String id;
  double number;
  String action;
  String target;
  String size;
  int? intensity;
  List<String> frames;
  int? time;
  String notes;
  int spot;

  Cue({
    required this.id,
    this.number = 0.0,
    this.action = '',
    this.target = '',
    this.size = '',
    this.intensity,
    this.frames = const [],
    this.time,
    this.notes = '',
    required this.spot,
  });

  @override
  String toString() {
    return 'spot: $spot id: $id : Cue $number - $action @ $intensity on $target over $time seconds';
  }

  factory Cue.fromJson(Map<String, dynamic> json) => _$CueFromJson(json);

  Map<String, dynamic> toJson() => _$CueToJson(this);

  Color getColor() => Colors.amber;

  String getFrames() => this.frames.join(' + ');
}
