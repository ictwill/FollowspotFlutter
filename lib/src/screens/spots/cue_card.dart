import 'package:flutter/material.dart';

import '../../data/number_helpers.dart';
import '../../models/cue.dart';
import '../../models/maneuver.dart';
import '../edit_cue/cue_edit_form.dart';

class CueCard extends StatelessWidget {
  const CueCard({
    Key? key,
    required this.item,
    required this.maneuver,
  }) : super(key: key);

  final Cue item;
  final Maneuver? maneuver;

  @override
  Widget build(BuildContext context) {
    if (item.id == 'blank') {
      return const Expanded(child: SizedBox.square(dimension: 32.0));
    } else {
      return Expanded(
        child: Card(
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
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 96.0,
                    alignment: Alignment.center,
                    color: maneuver?.getColor(),
                    child: Text(deleteTrailing(item.number),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: maneuver?.getContrastingTextColor() ??
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Column(
                        children: [
                          Table(
                            columnWidths: const <int, TableColumnWidth>{},
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                      child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        IconData(
                                            maneuver?.iconCodePoint ??
                                                Icons.check_box_outline_blank
                                                    .codePoint,
                                            fontFamily: maneuver?.fontFamily),
                                        color:
                                            Color(maneuver?.color ?? 0xFF77777),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(maneuver?.name ?? '-'),
                                    ],
                                  )),
                                  Text(
                                    item.target,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    item.size,
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(validateIntensity(
                                        intensity: item.intensity)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      item.frames.join(' + '),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      validateTime(time: item.time),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (item.notes.isNotEmpty)
                            Row(
                              children: [
                                Text(item.notes),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
