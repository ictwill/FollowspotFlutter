import 'package:flutter/cupertino.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/show.dart';
import 'package:uuid/uuid.dart';

import '../data/dummy_show.dart';

class ShowModel extends ChangeNotifier {
  final Show show = dummyShow();
  late List<double> usedNumbers = show.cueNumbers();

  final uuid = const Uuid();

  static final Cue blank = Cue(id: 'blank', action: 'spacer', spot: -1);
  Cue currentCue = blank;

  Cue findCue(int int, double number) {
    return show.spotList[int].cues.firstWhere(
      (element) => element.number == number,
      orElse: () => blank,
    );
  }

  void selectCue(Cue cue) {
    currentCue = cue;
  }

  void updateCue(int spot, Cue oldCue, Cue newCue) {
    int index = getSpotIndex(oldCue.spot);
    show.spotList[index].cues.removeWhere((element) => element.id == oldCue.id);
    if (oldCue.spot != newCue.spot) index = getSpotIndex(newCue.spot);
    addCue(index, newCue);
    refreshSpot(index);
  }

  void refreshSpot(int index) {
    show.spotList[index].cues.sort((a, b) => a.number.compareTo(b.number));
    usedNumbers = show.cueNumbers();
  }

  void addCue(int index, Cue newCue) {
    show.spotList[index].cues.add(newCue);
    notifyListeners();
  }

  void deleteCue(Cue oldCue) {
    int index = getSpotIndex(oldCue.spot);
    show.spotList[index].cues.removeWhere((element) => element.id == oldCue.id);
    refreshSpot(index);
    notifyListeners();
  }

  int getSpotIndex(int number) =>
      show.spotList.indexWhere((item) => item.number == number);
}
