import 'dart:io';

import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/screens/pdf_preview_screen.dart';
import 'package:followspot_application_1/src/screens/spots/spot_cues.dart';
import 'package:followspot_application_1/src/screens/spots/spot_tabs.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:followspot_application_1/src/screens/spots/cue_edit_view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/cue.dart';
import '../../my_menu_bar.dart';
import '../../settings/settings_view.dart';
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
                if (showModel.show.spotList.isNotEmpty) const SpotTabs(),
                if (showModel.show.spotList.isEmpty)
                  const BlankScreen()
                else
                  const SpotCues(),
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
              children: const [
                SpotTabs(),
                SpotCues(),
              ],
            ),
          );
        }
      },
    );
  }
}

Future<dynamic> navigateNewCue(BuildContext context, int spot) =>
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CueEditView(
            spot: spot, cue: Cue(id: const Uuid().v4(), spot: spot));
      },
    );

class BlankScreen extends StatelessWidget {
  const BlankScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Text('Open a Show or Start a New Show'));
  }
}
