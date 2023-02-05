import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/spots/cue_edit_view.dart';
import 'package:provider/provider.dart';

import '../settings/settings_view.dart';
import '../models/cue.dart';
import 'cue_card.dart';

/// Displays a list of Cues.
class SpotView extends StatelessWidget {
  const SpotView({
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
      body: Consumer<ShowModel>(
        builder: (context, showModel, child) {
          final int spots = showModel.show.spotList.length;
          final List<double> numbers = showModel.cueNumbers();

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
                    CueCard(item: showModel.findCue(i, number))
                ],
              );
            },
          );
        },
      ),
    );
  }
}
