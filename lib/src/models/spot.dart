import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/widgets.dart';

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
      orElse: () => Cue(id: 'blank', number: number, spot: this.number),
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

  List<Widget> getColorFrames() {
    Map<int, String> frameMap = frames.asMap();
    List<Widget> textWidgets = [];

    for (int index = 0; index < frameMap.length; index++) {
      String frameText = '${index + 1}. ${frameMap[index]}';

      textWidgets.add(Row(children: [
        Text(frameText, textScaleFactor: 0.7),
      ]));
    }
    return frames.map((e) => Text(' $e ', textScaleFactor: 0.7)).toList();
  }
}
