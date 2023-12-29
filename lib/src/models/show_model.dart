import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/spots/cue_card_single_line.dart';
import 'package:followspot_application_1/src/settings/cue_formats.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'cue.dart';
import 'maneuver.dart';
import 'show.dart';
import 'spot.dart';
import '../screens/spots/cue_card_multi_line.dart';
import '../data/dummy_show.dart';

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

  Cue findCue(int spotIndex, double number) =>
      show.spotList[spotIndex].findCue(number);

  void updateCue(Cue oldCue, Cue newCue) {
    int spotIndex;
    if (oldCue.spot != newCue.spot) {
      spotIndex = getSpotIndex(newCue.spot);
    } else {
      spotIndex = getSpotIndex(oldCue.spot);
    }
    deleteCue(oldCue);
    addCue(spotIndex, newCue);
    refreshNumbers();
    notifyListeners();
  }

  void refreshNumbers() => usedNumbers = show.cueNumbers();

  void addCue(int spotIndex, Cue newCue) =>
      show.spotList[spotIndex].addCue(newCue);

  void deleteCue(Cue oldCue) {
    int index = getSpotIndex(oldCue.spot);
    show.spotList[index].deleteCue(oldCue);
    refreshNumbers();
    notifyListeners();
  }

  int getSpotIndex(int spotNumber) =>
      show.spotList.indexWhere((spot) => spot.number == spotNumber);

  Map<int, String> getFrameList(int spot) =>
      show.spotList[getSpotIndex(spot)].frames.asMap();

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

  Widget getCueCard(int spotIndex, double number) {
    Cue cue = findCue(spotIndex, number);
    Maneuver? maneuver = show.getManeuver(cue.maneuver);
    String cueFrames = show.getCueFrames(spotIndex, cue.frames);

    return Visibility(
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        visible: cue.id == 'blank' ? false : true,
        child: getCardFormat(cue, maneuver, cueFrames));
  }

  Widget getCardFormat(Cue cue, Maneuver? maneuver, String cueFrames) {
    switch (settings.cueFormat) {
      case CueFormat.singleLine:
        return CueCardSingleLine(
            item: cue, maneuver: maneuver, frameString: cueFrames);
      case CueFormat.multiLine:
        return CueCardMultiLine(
            item: cue, maneuver: maneuver, frameString: cueFrames);
    }
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

  void openShow(String filePath) async {
    File file = File(filePath);
    String data = await file.readAsString();
    Map<String, dynamic> valueMap = await jsonDecode(data);
    show = Show.fromJson(valueMap);
    show.maneuverList.toList();
    show.filename = file.path;

    for (var spot in show.spotList) {
      spot.sortCues();
    }

    usedNumbers = show.cueNumbers();
    List<Maneuver> allManeuvers = [];

    for (var spot in show.spotList) {
      for (var cue in spot.cues) {
        if (cue.maneuver != null) {
          show.getManeuver(cue.maneuver!);
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

  void updateManeuverName(Maneuver maneuver, String newName) {
    int m = show.maneuverList
        .indexWhere((element) => element.name == maneuver.name);
    show.maneuverList[m].name = newName;
    notifyListeners();
  }
}
