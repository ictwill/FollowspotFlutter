import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/show_model.dart';
import '../../window_components/my_menu_bar.dart';
import '../responsive_layout.dart';
import '../window_components/blank_screen.dart';
import '../../../settings/settings_controller.dart';
import '../../window_components/status_bar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ShowModel>(builder: (context, model, child) {
        return Column(children: [
          MyMenuBar(settings: settings),
          if (model.show.spotList.isNotEmpty)
            Expanded(
                child: ResponsiveLayout(
              count: model.show.spotList.length,
              settings: settings,
            ))
          else
            BlankScreen(settings),
          const StatusBar()
        ]);
      }),
    );
  }
}
