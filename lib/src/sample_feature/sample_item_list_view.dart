import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/sample_feature/sample_item_details_view.dart';
import 'package:provider/provider.dart';

import '../settings/settings_view.dart';
import '../models/cue.dart';

/// Displays a list of Cues.
class CueListView extends StatelessWidget {
  const CueListView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Consumer<ShowModel>(
        builder: (context, show, child) {
          final int spots = show.cuelists.length;
          final List<double> numbers = show.cueNumbers();

          return ListView.builder(
            restorationId: 'sampleItemListView',
            itemCount: numbers.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (BuildContext context, int index) {
              final number = numbers[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < spots; i++)
                    CueCardCompact(item: show.findCue(i, number))
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class CueCardCompact extends StatelessWidget {
  const CueCardCompact({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Cue item;

  @override
  Widget build(BuildContext context) {
    if (item.id == -1) {
      return const Spacer();
    } else {
      return Expanded(
        child: Card(
          borderOnForeground: false,
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Provider.of<ShowModel>(context, listen: false).selectCue(item);
              Navigator.restorablePushNamed(
                context,
                SampleItemDetailsView.routeName,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColoredBox(
                  color: item.getColor(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 26.0, horizontal: 16.0),
                        child: Text(item.number,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )),
                      ),
                    ],
                  ),
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
                                  child: Text('${item.intensity} %'),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    item.frames.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
      );
    }
  }
}
