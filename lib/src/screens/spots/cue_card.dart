import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/maneuver.dart';
import 'package:followspot_application_1/src/screens/spots/cue_card_multi_line.dart';

class CueCard extends StatelessWidget {
  final Cue cue;
  final Maneuver? maneuver;

  const CueCard({super.key, required this.cue, this.maneuver});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        visible: cue.id == 'blank' ? false : true,
        child: CueCardMultiLine(
            item: cue, maneuver: maneuver, frameString: cue.getFrames()));
  }
}
