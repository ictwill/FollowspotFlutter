import 'package:flutter/material.dart';

import '../../data/number_helpers.dart';
import '../../models/cue.dart';
import '../../models/maneuver.dart';
import '../edit_cue/cue_edit_form.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    Key? key,
    required this.cue,
    required this.maneuver,
  }) : super(key: key);

  final Cue cue;
  final Maneuver? maneuver;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: maneuver?.getColor(),
      borderOnForeground: false,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return CueEditForm(cue: cue);
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 88.0,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(deleteTrailing(cue.number),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: maneuver?.getContrastingTextColor() ??
                            Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(
                    IconData(
                        maneuver?.iconCodePoint ??
                            Icons.check_box_outline_blank.codePoint,
                        fontFamily: maneuver?.fontFamily),
                    color: Color(maneuver?.color ?? 0xFF77777),
                  ),
                  const SizedBox(width: 8.0),
                  Text(maneuver?.name ?? '-'),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(cue.notes),
            ),
          ],
        ),
      ),
    );
  }
}
