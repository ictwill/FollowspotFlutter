import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Cue findCue(int spot, double number) {
    return show.spotList[spot].cues.firstWhere(
      (element) => element.number == number,
      orElse: () => blank,
    );
  }

  void selectCue(Cue cue) {
    currentCue = cue;
  }

  void updateCue(int spot, Cue oldCue, Cue newCue) {
    int index = getSpotIndex(oldCue.spot);
    deleteCue(oldCue);
    if (oldCue.spot != newCue.spot) index = getSpotIndex(newCue.spot);
    addCue(index, newCue);
    refreshSpot(index);
  }

  void refreshSpot(int index) {
    // show.spotList[index].cues.sort((a, b) => a.number.compareTo(b.number));
    usedNumbers = show.cueNumbers();
    notifyListeners();
  }

  void addCue(int index, Cue newCue) {
    show.spotList[index].cues.add(newCue);
  }

  void deleteCue(Cue oldCue) {
    int index = getSpotIndex(oldCue.spot);
    debugPrint(show.spotList[index].cues.length.toString());
    show.spotList[index].cues.remove(oldCue);
    debugPrint(show.spotList[index].cues.length.toString());
    refreshSpot(index);
  }

  int getSpotIndex(int number) =>
      show.spotList.indexWhere((spot) => spot.number == number);

  List<String> getFrameList(Cue cue) =>
      show.spotList[getSpotIndex(cue.spot)].frames;
}
