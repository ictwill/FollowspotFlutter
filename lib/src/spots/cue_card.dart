import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cue.dart';
import '../models/show_model.dart';
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
        child: Hero(
          tag: item.id,
          child: Card(
            borderOnForeground: false,
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CueEditView(spot: item.spot, cue: item)));
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text('${item.intensity} %'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      item.frames.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      '${item.time}  s',
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
