import 'package:flutter/material.dart';

import '../models/cue.dart';
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
                  return CueEditView(spot: item.spot, cue: item);
                },
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 96.0,
                  height: 80.0,
                  alignment: Alignment.center,
                  color: item.getColor(),
                  child: Text(deleteTrailing(item.number),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                          columnWidths: const <int, TableColumnWidth>{
                            1: FlexColumnWidth(2.0)
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(item.action),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                      '${validateIntensity(intensity: item.intensity)} %'),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    item.frames.join(' + '),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
      );
    }
  }
}

String validateIntensity({int? intensity}) =>
    intensity != null && intensity >= 0 ? '$intensity' : '0';

String validateTime({int? time}) => time != null && time >= 0 ? '$time' : '0';
