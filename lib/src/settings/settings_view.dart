import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/pdf_preview_screen.dart';
import 'package:pdf/pdf.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final leftController = TextEditingController();
    final topController = TextEditingController();
    final rightController = TextEditingController();
    final bottomController = TextEditingController();

    leftController.text =
        '${controller.pageFormat.marginLeft / PdfPageFormat.inch}';
    topController.text =
        '${controller.pageFormat.marginTop / PdfPageFormat.inch}';
    rightController.text =
        '${controller.pageFormat.marginRight / PdfPageFormat.inch}';
    bottomController.text =
        '${controller.pageFormat.marginBottom / PdfPageFormat.inch}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: ListView(
          children: [
            Row(
              children: [
                const Text('Theme:  '),
                DropdownButton<ThemeMode>(
                  // Read the selected themeMode from the controller
                  value: controller.themeMode,
                  // Call the updateThemeMode method any time the user selects a theme.
                  onChanged: controller.updateThemeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    )
                  ],
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: topController,
              decoration: const InputDecoration(labelText: 'Top:'),
              onEditingComplete: () => controller.setMargin(
                  PrintMargins.top, double.parse(topController.text)),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: leftController,
                    decoration: const InputDecoration(labelText: 'Left:'),
                    onEditingComplete: () => controller.setMargin(
                        PrintMargins.left, double.parse(leftController.text)),
                  ),
                ),
                Expanded(
                  child: TextField(
                      controller: rightController,
                      decoration: const InputDecoration(labelText: 'Right:'),
                      onEditingComplete: () => controller.setMargin(
                          PrintMargins.right,
                          double.parse(rightController.text))),
                ),
              ],
            ),
            TextField(
                controller: bottomController,
                decoration: const InputDecoration(labelText: 'Bottom:'),
                onEditingComplete: () => controller.setMargin(
                    PrintMargins.bottom, double.parse(bottomController.text))),
          ],
        ),
      ),
    );
  }
}
