import 'cue.dart';

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

  Cue findCue(double number) {
    return cues.firstWhere(
      (element) => element.number == number,
      orElse: () => Cue(id: 'blank', spot: this.number),
    );
  }
}
