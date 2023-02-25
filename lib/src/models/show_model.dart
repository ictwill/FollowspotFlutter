import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/data/dummy_show.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/show.dart';
import 'package:followspot_application_1/src/models/spot.dart';
import 'package:uuid/uuid.dart';

import 'maneuver.dart';

class ShowModel extends ChangeNotifier {
  Show show = dummyShow();
  late List<double> usedNumbers = show.cueNumbers();

  final uuid = const Uuid();

  Cue currentCue = Cue(id: 'blank', spot: -1);

  Cue findCue(int spot, double number) {
    if (show.spotList[spot].cues.isNotEmpty) {
      return show.spotList[spot].cues.singleWhere(
        (element) => element.number == number,
        orElse: () => Cue(id: 'blank', spot: spot),
      );
    } else {
      return Cue(id: 'blank', spot: spot);
    }
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

  List<String> getFrameList(int spot) =>
      show.spotList[getSpotIndex(spot)].frames;

  void closeShow() {
    show = Show(info: ShowInfo(date: DateTime.now()), maneuverList: []);
    notifyListeners();
  }

  void newShow() {
    show = Show(info: ShowInfo(date: DateTime.now()), spotList: [
      Spot(id: 0, number: 1, frames: [], cues: []),
      Spot(id: 1, number: 2, frames: [], cues: []),
    ], maneuverList: [
      Maneuver(
          name: 'Fade Up', color: Colors.green.value, icon: Icons.arrow_upward),
      Maneuver(
          name: 'Fade Down',
          color: Colors.yellow.value,
          icon: Icons.arrow_downward),
      Maneuver(
          name: 'Fade Out',
          color: Colors.red.value,
          icon: Icons.arrow_circle_down),
    ]);
    notifyListeners();
  }

  void getDummyShow() {
    show = dummyShow();
    notifyListeners();
  }

  void openShow(String showFromFile) async {
    Map<String, dynamic> valueMap = await jsonDecode(showFromFile);
    show = Show.fromJson(valueMap);

    usedNumbers = show.cueNumbers();

    notifyListeners();
  }

  Maneuver getManeuver(String text) {
    return show.maneuverList.firstWhere(
      (element) => element.name.toLowerCase() == text.toLowerCase(),
      orElse: () {
        Maneuver newManeuver = Maneuver(name: text);
        return show.addManeuver(newManeuver);
      },
    );
  }

  void updateManeuver(Color value, Maneuver maneuver) {
    show.maneuverList
        .singleWhere((element) => element.name == maneuver.name)
        .color = value.value;

    notifyListeners();
  }
}
