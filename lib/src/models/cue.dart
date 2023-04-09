import 'package:json_annotation/json_annotation.dart';

part 'cue.g.dart';

@JsonSerializable(explicitToJson: true)
class Cue {
  String id;
  double number;
  String? maneuver;
  String target;
  String size;
  int? intensity;
  List<int> frames;
  int? time;
  String notes;
  int spot;

  Cue({
    required this.id,
    this.number = 0.0,
    this.maneuver,
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
    return 'spot: $spot id: $id : Cue $number - $maneuver : '
        ' @ $intensity on $target over $time seconds';
  }

  factory Cue.fromJson(Map<String, dynamic> json) => _$CueFromJson(json);

  Map<String, dynamic> toJson() => _$CueToJson(this);

  String getFrames() => frames.join(' + ');
}
