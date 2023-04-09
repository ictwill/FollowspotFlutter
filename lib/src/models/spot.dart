import 'package:json_annotation/json_annotation.dart';

import 'cue.dart';

part 'spot.g.dart';

@JsonSerializable(explicitToJson: true)
class Spot {
  int id = -1;
  int number = -1;
  List<String> frames = [];
  List<Cue> cues = [];

  Spot(
      {required this.id,
      required this.number,
      required this.frames,
      required this.cues});

  factory Spot.fromJson(Map<String, dynamic> json) => _$SpotFromJson(json);

  Map<String, dynamic> toJson() => _$SpotToJson(this);

  Cue findCue(double number) {
    return cues.firstWhere(
      (element) => element.number == number,
      orElse: () => Cue(id: 'spacer', number: number, spot: this.number),
    );
  }

  void addCue(Cue newCue) {
    cues.add(newCue);
    sortCues();
  }

  void deleteCue(Cue deletedCue) {
    cues.remove(deletedCue);
  }

  void sortCues() => cues.sort((a, b) => a.number.compareTo(b.number));
}
