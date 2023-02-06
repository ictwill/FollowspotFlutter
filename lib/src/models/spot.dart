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
}
