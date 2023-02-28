import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/spots/cue_edit_form.dart';

import '../../models/cue.dart';
import 'cue_edit_view.dart';

class CueCard extends StatelessWidget {
  const CueCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Cue item;

  @override
  Widget build(BuildContext context) {
    if (item.id == 'blank') {
      return const Spacer();
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
                    color: item.maneuver?.getColor(),
                    child: Text(deleteTrailing(item.number),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
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
                                        item.maneuver?.icon,
                                        color: Color(
                                            item.maneuver?.color ?? 0xFF77777),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(item.maneuver?.name ?? '-'),
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
                                    child: Text(
                                        '${validateIntensity(intensity: item.intensity)} %'),
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
                                      '${validateTime(time: item.time)} ct',
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

String validateIntensity({int? intensity}) =>
    intensity != null && intensity >= 0 ? '$intensity' : '';

String validateTime({int? time}) => time != null && time >= 0 ? '$time' : '';
String deleteTrailing(double number) {
  var string = number.toString();
  while (string.endsWith('0') && string.contains('.0')) {
    string = _dropLast(string);
    if (string.endsWith('.')) return _dropLast(string);
  }
  return string;
}

String _dropLast(string) => string.substring(0, string.length - 1);
