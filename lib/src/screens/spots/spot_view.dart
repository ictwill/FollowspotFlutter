import 'dart:io';

import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/screens/pdf_preview_screen.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:followspot_application_1/src/screens/spots/cue_edit_view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/cue.dart';
import '../../my_menu_bar.dart';
import '../../settings/settings_view.dart';
import 'cue_card.dart';
import 'status_bar.dart';

/// Displays a list of Cues.
class SpotView extends StatelessWidget {
  SpotView({super.key, required this.settings});

  static const routeName = '/';
  final uuid = const Uuid();
  final SettingsController settings;
  final bool isDesktop =
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, showModel, child) {
        if (isDesktop) {
          //Desktop Scaffold with MenuBar and StatusBar
          return Scaffold(
            body: Column(
              children: [
                MyMenuBar(settings: settings),
                if (showModel.show.spotList.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 0; i < showModel.show.spotList.length; i++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: ElevatedButton(
                              autofocus: true,
                              onPressed: () => navigateNewCue(context, i + 1),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Spot ${i + 1}',
                                      textScaleFactor: 1.7,
                                    ),
                                    const Text('Add Cue'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).canvasColor,
                          Colors.transparent,
                          Colors.transparent,
                          Theme.of(context).canvasColor,
                        ],
                        stops: const [0.0, 0.025, 0.975, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.builder(
                      findChildIndexCallback: (key) {},
                      restorationId: 'spotListView',
                      itemCount: showModel.usedNumbers.length,
                      padding: const EdgeInsets.all(12.0),
                      itemBuilder: (BuildContext context, int index) {
                        final number = showModel.usedNumbers[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                                i < showModel.show.spotList.length;
                                i++)
                              CueCard(item: showModel.findCue(i, number))
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (showModel.show.spotList.isEmpty)
                  const Expanded(
                      child: Text('Open a Show or Start a New Show')),
                const StatusBar()
              ],
            ),
          );
        } else {
          //Mobile Layout with AppBar
          return Scaffold(
            appBar: AppBar(
              title: Text(showModel.show.info.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to the settings page. If the user leaves and returns
                    // to the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    Navigator.restorablePushNamed(
                        context, SettingsView.routeName);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, PdfPreviewScreen.routeName);
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < showModel.show.spotList.length; i++)
                      Column(
                        children: [
                          Text(
                            'Spot ${i + 1}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          OutlinedButton(
                            onPressed: () => navigateNewCue(context, i + 1),
                            child: const Text('New Cue'),
                          ),
                        ],
                      )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    restorationId: 'spotListView',
                    itemCount: showModel.usedNumbers.length,
                    padding: const EdgeInsets.all(12.0),
                    itemBuilder: (BuildContext context, int index) {
                      final number = showModel.usedNumbers[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0;
                              i < showModel.show.spotList.length;
                              i++)
                            CueCard(item: showModel.findCue(i, number))
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<dynamic> navigateNewCue(BuildContext context, int spot) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CueEditView(spot: spot, cue: Cue(id: uuid.v4(), spot: spot));
        },
      );
}
