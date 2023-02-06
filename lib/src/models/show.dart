import 'spot.dart';

class Show {
  final int id;
  final ShowInfo info;
  final List<Spot> spotList = List.generate(
      2,
      (index) => Spot(
          id: index,
          number: index + 1,
          frames: ['R132', 'R119', 'L202', 'L203', 'L205', 'L206'],
          cues: []));

  Show({
    this.id = -1,
    required this.info,
  });

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
}

class ShowInfo {
  final int id;
  final String title;
  final String location;
  final String ld;
  final String ald;
  final DateTime date;

  ShowInfo(
      {required this.id,
      this.title = '',
      this.location = '',
      this.ld = '',
      this.ald = '',
      required this.date});
}
