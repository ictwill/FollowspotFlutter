import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/data/dummy_show.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/show.dart';
import 'package:followspot_application_1/src/models/spot.dart';
import 'package:followspot_application_1/src/screens/spots/cue_card.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'maneuver.dart';

class ShowModel extends ChangeNotifier {
  Show show = Show(info: ShowInfo(date: DateTime(0)));

  late List<double> usedNumbers = show.cueNumbers();

  final uuid = const Uuid();

  Cue currentCue = Cue(id: 'blank', spot: -1);

  String message = '';

  Cue findCue(int spot, double number) {
    if (show.spotList[spot].cues.isNotEmpty) {
      return show.spotList[spot].cues.firstWhere(
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
        name: 'Fade Up',
        color: Colors.green.value,
        iconCodePoint: Icons.arrow_upward.codePoint,
      ),
      Maneuver(
          name: 'Fade Down',
          color: Colors.yellow.value,
          iconCodePoint: Icons.arrow_downward.codePoint),
      Maneuver(
          name: 'Fade Out',
          color: Colors.red.value,
          iconCodePoint: Icons.arrow_circle_down.codePoint),
    ]);
    notifyListeners();
  }

  void getDummyShow() {
    show = dummyShow();
    notifyListeners();
  }

  void openShow(String showFromFile, File file) async {
    Map<String, dynamic> valueMap = await jsonDecode(showFromFile);
    show = Show.fromJson(valueMap);
    show.maneuverList.toList();
    show.filename = file.path;

    usedNumbers = show.cueNumbers();
    List<Maneuver> allManeuvers = [];

    show.spotList.forEach((e) => e.cues.forEach((e) {
          if (e.maneuver != null) {
            show.getManeuver(e.maneuver!);
          }
        }));
    allManeuvers.sort((a, b) => a.name.compareTo(b.name));
    allManeuvers.forEach((element) {
      show.addManeuver(element);
    });
    message = 'Opened ${file.path} - ${getCurrentTime()}';
    notifyListeners();
  }

  void updateManeuverColor(Maneuver maneuver, Color color) {
    show.maneuverList
        .singleWhere((element) => element.name == maneuver.name)
        .color = color.value;
    notifyListeners();
  }

  void updateManeuverIcon(Maneuver maneuver, IconData iconData) {
    int m = show.maneuverList
        .indexWhere((element) => element.name == maneuver.name);
    show.maneuverList[m].fontFamily = iconData.fontFamily;
    show.maneuverList[m].iconCodePoint = iconData.codePoint;
    notifyListeners();
  }

  void deleteManeuver(Maneuver maneuver) {
    show.deleteManeuver(maneuver);
    notifyListeners();
  }

  Widget getCueCard(int spot, double number) {
    Cue cue = findCue(spot, number);
    Maneuver? maneuver = show.getManeuver(cue.maneuver);
    return CueCard(item: cue, maneuver: maneuver);
  }

  Future<void> saveAs() async {
    {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: '${show.info.title}.spot',
      );

      if (outputFile == null) {
        // User canceled the picker
      } else {
        save(outputFile);
      }

      debugPrint('Save as selected');
    }
  }

  void save(String outputFile) {
    File file = File(outputFile);
    file.writeAsString(jsonEncode(show.toJson()));

    file.create(recursive: true);
    show.filename = outputFile;

    message = 'Saved ${show.filename} - ${getCurrentTime()}';
    notifyListeners();
  }

  String getCurrentTime() => DateFormat('hh:mm:ss').format(DateTime.now());

  void addFrame(int id) {
    show.spotList.singleWhere((element) => element.id == id).frames.add('');
    notifyListeners();
  }

  void updateFrame(int spotId, int index, String value) {
    show.spotList.singleWhere((element) => element.id == spotId).frames[index] =
        value;
    notifyListeners();
  }
}
