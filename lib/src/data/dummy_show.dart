import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/cue.dart';
import '../models/maneuver.dart';
import '../models/show.dart';
import '../models/spot.dart';

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
      maneuverList: [
        Maneuver(
          name: 'Fade Up',
          color: Colors.green.value,
          iconCodePoint: Icons.arrow_upward_rounded.codePoint,
        ),
        Maneuver(
            name: 'Fade Down',
            color: Colors.orange.value,
            iconCodePoint: Icons.arrow_downward_rounded.codePoint),
        Maneuver(
            name: 'Fade Out',
            color: Colors.red.value,
            iconCodePoint: Icons.arrow_circle_down.codePoint),
      ]);

  var uuid = const Uuid();

  for (var spot in show.spotList) {
    spot.cues = List.generate(
      50,
      (index) => Cue(
        id: uuid.v4(),
        number: (1 + index).toDouble(),
        spot: spot.number,
        target: 'Cinderella',
      ),
    );
  }
  return show;
}
