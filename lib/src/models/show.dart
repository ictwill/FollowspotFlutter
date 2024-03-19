import 'package:basic_utils/basic_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import 'maneuver.dart';
import 'spot.dart';

part 'show.g.dart';

@JsonSerializable(explicitToJson: true)
class Show {
  String? filename;
  final int id;
  final ShowInfo info;
  List<Spot> spotList;
  List<Maneuver> maneuverList;

  Show(
      {this.filename,
      this.id = -1,
      required this.info,
      this.spotList = const <Spot>[],
      this.maneuverList = const <Maneuver>[]});

  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);

  Map<String, dynamic> toJson() => _$ShowToJson(this);

  //Get a list of every cue number used in the show.
  List<double> cueNumbers() {
    Set<double> numbers = {};
    for (var spots in spotList) {
      for (var cue in spots.cues) {
        numbers.add(cue.number);
      }
    }
    final List<double> sorted = numbers.toList();
    sorted.sort();

    return sorted;
  }

  Maneuver? getManeuver(String? text) {
    if (text != null && text.isNotEmpty) {
      return maneuverList.firstWhere(
        (element) => element.name.toLowerCase() == text.toLowerCase(),
        orElse: () {
          Maneuver newManeuver =
              Maneuver(name: StringUtils.capitalize(text, allWords: true));
          return addManeuver(newManeuver);
        },
      );
    } else {
      return null;
    }
  }

  Maneuver addManeuver(Maneuver maneuver) {
    maneuverList.toList(growable: true);
    if (!maneuverList.contains(maneuver)) maneuverList.add(maneuver);

    return maneuverList.firstWhere(
        (element) => element.name.toLowerCase() == maneuver.name.toLowerCase());
  }

  void deleteManeuver(Maneuver maneuver) {
    maneuverList.remove(maneuver);
  }

  String getCueFrames(int spotIndex, List<int> frames) {
    String string = frames.map((frame) {
      final spotFrame = spotList[spotIndex].frames[frame];
      final String cueFrame = 'F${frame + 1}: $spotFrame';
      return cueFrame;
    }).join(' + ');

    return string;
  }

  void toggleManeuverHeader(Maneuver maneuver, bool newvalue) {
    int i = maneuverList.indexOf(maneuver);
    maneuverList.elementAt(i).header = newvalue;
  }
}

enum Info {
  title,
  location,
  ld,
  ald,
  date,
}

@JsonSerializable()
class ShowInfo {
  final int id;
  String title;
  String location;
  String ld;
  String ald;
  DateTime date;

  ShowInfo(
      {this.id = -1,
      this.title = '',
      this.location = '',
      this.ld = '',
      this.ald = '',
      required this.date});

  factory ShowInfo.fromJson(Map<String, dynamic> json) =>
      _$ShowInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ShowInfoToJson(this);
}
