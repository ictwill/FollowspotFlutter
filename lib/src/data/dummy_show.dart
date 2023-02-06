import 'dart:math';

import 'package:followspot_application_1/src/models/cue.dart';
import 'package:uuid/uuid.dart';

import '../models/show.dart';

Show dummyShow() {
  Show show = Show(
    id: 1,
    info: ShowInfo(id: 1, date: DateTime.now()),
  );
  var uuid = const Uuid();

  for (var spot in show.spotList) {
    spot.cues = List.generate(
      50,
      (index) => Cue(
        id: uuid.v4(),
        number: index + 1 + (Random().nextInt(10)).toDouble(),
        spot: spot.number,
      ),
    );
  }
  return show;
}
