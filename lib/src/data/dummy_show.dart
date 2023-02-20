import 'dart:math';

import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/spot.dart';
import 'package:uuid/uuid.dart';

import '../models/maneuver.dart';
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
      maneuverList: [
        Maneuver(
            name: 'Fade Up',
            color: Colors.green.value,
            icon: Icons.arrow_upward_rounded),
        Maneuver(
            name: 'Fade Down',
            color: Colors.orange.value,
            icon: Icons.arrow_downward_rounded),
        Maneuver(
            name: 'Fade Out',
            color: Colors.red.value,
            icon: Icons.arrow_circle_down),
      ]);

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
