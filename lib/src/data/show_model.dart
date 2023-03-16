import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/cue.dart';
import '../models/maneuver.dart';
import '../models/show.dart';
import '../models/spot.dart';
import '../screens/spots/cue_card.dart';
import 'dummy_show.dart';

class ShowModel extends ChangeNotifier {
  Show show = Show(info: ShowInfo(date: DateTime(0)));

  late List<double> usedNumbers = show.cueNumbers();

  final uuid = const Uuid();

  Cue currentCue = Cue(id: 'blank', spot: -1);

  String message = '';

  late SettingsController settings;

  ShowModel(SettingsController settingsController) {
    settings = settingsController;
  }

  Cue findCue(int spotIndex, double number) {
    if (show.spotList[spotIndex].cues.isNotEmpty) {
      return show.spotList[spotIndex].cues.firstWhere(
        (element) => element.number == number,
        orElse: () {
          return Cue(
            id: 'spacer',
            number: number,
            spot: spotIndex,
          );
        },
      );
    } else {
      return Cue(
        id: 'spacer',
        number: number,
        spot: spotIndex,
      );
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
    notifyListeners();
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

  ///     Maneuvers
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
    return Visibility(
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        visible: cue.id == 'spacer' ? false : true,
        child: CueCard(item: cue, maneuver: maneuver));
  }

  Future<void> saveAs() async {
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        allowedExtensions: ['spot'],
        type: FileType.custom);

    if (outputFile == null) {
      // User canceled the picker
    } else {
      if (!outputFile.endsWith('.spot')) {
        outputFile = '${outputFile.split('.').first}.spot';
      }
      save(outputFile);
    }
    debugPrint('Save as $outputFile');
  }

  void openShow(String showFromFile, File file) async {
    Map<String, dynamic> valueMap = await jsonDecode(showFromFile);
    show = Show.fromJson(valueMap);
    show.maneuverList.toList();
    show.filename = file.path;

    usedNumbers = show.cueNumbers();
    List<Maneuver> allManeuvers = [];

    for (var e in show.spotList) {
      for (var e in e.cues) {
        if (e.maneuver != null) {
          show.getManeuver(e.maneuver!);
        }
      }
    }
    allManeuvers.sort((a, b) => a.name.compareTo(b.name));
    for (var element in allManeuvers) {
      show.addManeuver(element);
    }
    message = 'Opened: ${file.uri.pathSegments.last} @ ${getCurrentTime()}';
    settings.addRecentFile(file.path);

    notifyListeners();
  }

  void save(String outputFile) {
    updateTime();
    File file = File(outputFile);
    file.writeAsString(jsonEncode(show.toJson()));

    file.create(recursive: true);
    show.filename = outputFile;
    settings.addRecentFile(outputFile);

    message = 'Saved: ${file.uri.pathSegments.last} @ ${getCurrentTime()}';
    notifyListeners();
  }

  String getCurrentTime() => DateFormat('HH:mm:ss').format(DateTime.now());

  void addFrame(int id) {
    show.spotList.singleWhere((element) => element.id == id).frames.add('');
    notifyListeners();
  }

  void updateFrame(int spotId, int index, String value) {
    show.spotList.singleWhere((element) => element.id == spotId).frames[index] =
        value;
    notifyListeners();
  }

  void updateShow(Info field, String value) {
    switch (field) {
      case Info.title:
        show.info.title = value;
        break;
      case Info.location:
        show.info.location = value;
        break;
      case Info.ld:
        show.info.ld = value;
        break;
      case Info.ald:
        show.info.ald = value;
        break;
      default:
    }
    notifyListeners();
  }

  void updateTime() => show.info.date = DateTime.now();
}
