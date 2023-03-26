import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/responsive/layouts/multi_cuelist_view.dart';
import 'package:followspot_application_1/src/screens/responsive/layouts/spot_tab_view.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.count,
    required this.settings,
  });
  final int count;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileWidth) {
          return const MultiCueListView();
        } else {
          return SpotTabView(spotCount: count, settings: settings);
        }
      },
    );
  }
}
