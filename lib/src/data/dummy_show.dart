import 'dart:math';

import 'package:followspot_application_1/src/models/cue.dart';
import 'package:uuid/uuid.dart';

import '../models/show.dart';

Show dummyShow() {
  Show show = Show(
    filename: 'dummyshowtest',
    id: 1,
    info: ShowInfo(
        id: 1,
        date: DateTime.now(),
        title: 'The Curious Incident of the Dog in the Nighttime',
        ld: 'Allison Alligator',
        ald: 'Kirby Kangaroo'),
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
