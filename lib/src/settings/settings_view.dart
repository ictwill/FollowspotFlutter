import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

import '../screens/printing/pdf_preview_screen.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: topController,
                    decoration: const InputDecoration(labelText: 'Top:'),
                    onEditingComplete: () => controller.setMargin(
                        PrintMargins.top, double.parse(topController.text)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: leftController,
                    decoration: const InputDecoration(labelText: 'Left:'),
                    onEditingComplete: () => controller.setMargin(
                        PrintMargins.left, double.parse(leftController.text)),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(16.0),
                    color: Colors.white,
                    width: controller.pageFormat.width / 3,
                    height: controller.pageFormat.height / 3,
                    child: Container(
                      color: Colors.grey.shade400,
                      margin: EdgeInsets.fromLTRB(
                        controller.pageFormat.marginLeft / 3,
                        controller.pageFormat.marginTop / 3,
                        controller.pageFormat.marginRight / 3,
                        controller.pageFormat.marginBottom / 3,
                      ),
                    )),
                SizedBox(
                  width: 100,
                  child: TextField(
                      textAlign: TextAlign.center,
                      controller: rightController,
                      decoration: const InputDecoration(labelText: 'Right:'),
                      onEditingComplete: () => controller.setMargin(
                          PrintMargins.right,
                          double.parse(rightController.text))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                      textAlign: TextAlign.center,
                      controller: bottomController,
                      decoration: const InputDecoration(labelText: 'Bottom:'),
                      onEditingComplete: () => controller.setMargin(
                          PrintMargins.bottom,
                          double.parse(bottomController.text))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
