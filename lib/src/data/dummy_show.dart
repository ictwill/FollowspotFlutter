import 'dart:math';

import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/spot.dart';
import 'package:uuid/uuid.dart';

import '../models/show.dart';

Show dummyShow() {
  Show show = Show(
    filename: 'dummyshowtest',
    id: 1,
    info: ShowInfo(
        id: 1,
        date: DateTime.now(),
        title: 'Hamilton',
        ld: 'Allison Alligator',
        ald: 'Kirby Kangaroo'),
    spotList: List.generate(
      2,
      (index) => Spot(
        id: index,
        number: index + 1,
        frames: ['R132', 'R119', 'L202', 'L203', 'L205', 'L206'],
        cues: [],
      ),
    ),
  );

  var uuid = const Uuid();

  for (var spot in show.spotList) {
    spot.cues = List.generate(
      50,
      (index) => Cue(
        id: uuid.v4(),
        number: (index + 1 + Random().nextInt(4)).toDouble(),
        spot: spot.number,
        target: 'Cinderella',
      ),
    );
  }
  return show;
}
