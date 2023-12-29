import 'package:flutter/material.dart';

import '../../data/number_helpers.dart';
import '../../models/cue.dart';
import '../../models/maneuver.dart';
import '../edit_cue/cue_edit_form.dart';

class CueCardSingleLine extends StatelessWidget {
  const CueCardSingleLine({
    Key? key,
    required this.item,
    required this.maneuver,
    required this.frameString,
  }) : super(key: key);

  final Cue item;
  final String frameString;
  final Maneuver? maneuver;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return CueEditForm(cue: item);
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 88.0,
              alignment: Alignment.center,
              color: maneuver?.getColor(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(deleteTrailing(item.number),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: maneuver?.getContrastingTextColor() ??
                            Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16.0),
            Row(
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
            Expanded(
                flex: 2,
                child: Text(
                  item.target,
                  textAlign: TextAlign.center,
                )),
            Expanded(child: Text(item.size)),
            Expanded(
                child: Text(
              validateIntensity(intensity: item.intensity),
              textAlign: TextAlign.center,
            )),
            Expanded(flex: 2, child: Text(frameString)),
            Expanded(
                child: Text(
              validateTime(time: item.time),
              textAlign: TextAlign.center,
            )),
            Expanded(flex: 2, child: Text(item.notes)),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
    );
  }
}
