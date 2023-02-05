import 'spot.dart';

class Show {
  final int id;
  final ShowInfo info;
  final List<Spot> spotList = List.generate(
      2,
      (index) => Spot(index, index + 1,
          ['R132', 'R119', 'L202', 'L203', 'L205', 'L206'], []));

  Show({
    this.id = -1,
    required this.info,
  });
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
