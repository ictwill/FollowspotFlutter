import 'package:flutter/cupertino.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/show.dart';

import '../data/dummy_show.dart';

class ShowModel extends ChangeNotifier {
  final Show show = dummyShow();

  static final Cue blank = Cue(action: 'spacer');
  Cue currentCue = blank;

  //Get a list of every cue number used in the show.
  List<double> cueNumbers() {
    Set<double> numbers = {};
    for (var spots in show.spotList) {
      for (var cue in spots.cues) {
        numbers.add(cue.number);
      }
    }
    final List<double> sorted = numbers.toList();
    sorted.sort();

    return sorted;
  }

  Cue findCue(int int, double number) {
    return show.spotList[int].cues.firstWhere(
      (element) => element.number == number,
      orElse: () => blank,
    );
  }

  void selectCue(Cue cue) {
    currentCue = cue;
  }

  void updateCue(Cue cue, Cue newCue) {}
}
