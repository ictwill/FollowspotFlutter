import 'cue.dart';

class Spot {
  int id = -1;
  int number = -1;
  List<String> frames = [];
  List<Cue> cues = [];

  Spot(this.id, this.number, this.frames, this.cues);
}
