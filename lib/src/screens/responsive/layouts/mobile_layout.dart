import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/responsive/layouts/spot_tab_view.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

import '../../../models/show_model.dart';
import '../../../settings/settings_view.dart';
import '../../printing/pdf_preview_screen.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.show.info.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
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
        body: SpotTabView(
            settings: settings, spotCount: model.show.spotList.length),
      ),
    );
  }
}
