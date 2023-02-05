import 'dart:math';

import 'package:followspot_application_1/src/models/cue.dart';

import '../models/show.dart';

Show dummyShow() {
  Show show = Show(
    id: 1,
    info: ShowInfo(id: 1, date: DateTime.now()),
  );

  for (var element in show.spotList) {
    element.cues = List.generate(
      50,
      (index) => Cue(
        id: index + 1000,
        number: index + 1 + (Random().nextInt(10)).toDouble(),
      ),
    );
  }
  return show;
}
