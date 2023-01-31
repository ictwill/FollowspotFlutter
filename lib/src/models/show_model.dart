import 'package:flutter/cupertino.dart';
import 'package:followspot_application_1/src/models/cue.dart';

class ShowModel extends ChangeNotifier {
  final List<List<Cue>> _cuelists = [
    const [
      Cue(1, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '1'),
      Cue(2, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '2'),
      Cue(3, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'],
          'Fade out with exit', '3'),
      Cue(4, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '4'),
      Cue(5, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '5'),
      Cue(6, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '6'),
      Cue(7, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '7'),
      Cue(8, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '8'),
      Cue(9, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '9'),
      Cue(10, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '10'),
      Cue(11, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '11'),
      Cue(12, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '12'),
      Cue(13, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '13'),
      Cue(14, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '14'),
      Cue(15, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '15'),
      Cue(16, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '16'),
      Cue(17, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '17'),
      Cue(18, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '18'),
      Cue(19, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '19'),
      Cue(20, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '20'),
      Cue(21, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '21'),
    ],
    const [
      Cue(22, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '3'),
      Cue(23, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '4'),
      Cue(24, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '5'),
      Cue(25, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '8'),
      Cue(26, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '11'),
      Cue(27, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '17'),
      Cue(28, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '26'),
      Cue(29, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '27'),
      Cue(30, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '28'),
      Cue(31, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '29'),
      Cue(32, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '30'),
      Cue(33, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '31'),
      Cue(34, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '32'),
      Cue(35, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '33'),
      Cue(36, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '34'),
      Cue(37, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '35'),
      Cue(38, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '36'),
      Cue(39, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '37'),
      Cue(40, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '38'),
      Cue(41, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '39'),
      Cue(42, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '40'),
      Cue(43, 'Fade Up', 'Bob', 2, 'Full Body', 50, ['R132', 'L202'], '', '41'),
    ]
  ];
  final Cue blank = const Cue(-1, '', '', 0, '', 0, [], '', '');

  //Get a list of every cue number used in the show.
  List<double> cueNumbers() {
    Set<double> numbers = {};
    for (var cuelist in _cuelists) {
      for (var cue in cuelist) {
        numbers.add(double.parse(cue.number));
      }
    }
    final List<double> sorted = numbers.toList();
    sorted.sort();

    return sorted;
  }

  Cue findCue(int int, double number) {
    return cuelists[int].firstWhere(
      (element) => double.parse(element.number) == number,
      orElse: () => blank,
    );
  }

  List<List<Cue>> get cuelists {
    return _cuelists;
  }
}
