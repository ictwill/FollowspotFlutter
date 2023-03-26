import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/data/show_model.dart';
import 'package:provider/provider.dart';

import '../../navigation.dart';

class MultiCueListView extends StatelessWidget {
  const MultiCueListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, model, child) => Column(
        children: [
          PhysicalModel(
            elevation: 8,
            color: Theme.of(context).cardColor,
            child: Row(
              children: model.show.spotList
                  .map((spot) => Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateNewCue(context, spot.number);
                          },
                          child: Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Spot ${spot.number}',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.add,
                                    color: Theme.of(context).hintColor)
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              restorationId: 'spotListView',
              itemCount: model.usedNumbers.length,
              padding: const EdgeInsets.all(24.0),
              itemBuilder: (BuildContext context, int index) {
                final number = model.usedNumbers[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < model.show.spotList.length; i++)
                      Expanded(child: model.getCueCard(i, number))
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
