import 'package:json_annotation/json_annotation.dart';

import 'maneuver.dart';
import 'spot.dart';

part 'show.g.dart';

@JsonSerializable(explicitToJson: true)
class Show {
  String filename;
  final int id;
  final ShowInfo info;
  List<Spot> spotList;
  final List<Maneuver> maneuverList;

  Show(
      {this.filename = '',
      this.id = -1,
      required this.info,
      this.spotList = const <Spot>[],
      this.maneuverList = const []});

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

  Maneuver addManeuver(Maneuver maneuver) {
    maneuverList.add(maneuver);
    return maneuverList.firstWhere(
        (element) => element.name.toLowerCase() == maneuver.name.toLowerCase());
  }
}

@JsonSerializable()
class ShowInfo {
  final int id;
  final String title;
  final String location;
  final String ld;
  final String ald;
  DateTime date;

  ShowInfo(
      {this.id = -1,
      this.title = '-',
      this.location = '-',
      this.ld = '-',
      this.ald = '-',
      required this.date});

  factory ShowInfo.fromJson(Map<String, dynamic> json) =>
      _$ShowInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ShowInfoToJson(this);
}
