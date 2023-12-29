import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:followspot_application_1/src/data/number_helpers.dart';
import 'package:followspot_application_1/src/settings/cue_formats.dart';
import 'package:pdf/pdf.dart';

import '../printing/pdf_preview_screen.dart';
import '../../settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  final leftController = TextEditingController();
  final topController = TextEditingController();
  final rightController = TextEditingController();
  final bottomController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    leftController.text =
        '${widget.controller.pageFormat.marginLeft / PdfPageFormat.inch}';
    topController.text =
        '${widget.controller.pageFormat.marginTop / PdfPageFormat.inch}';
    rightController.text =
        '${widget.controller.pageFormat.marginRight / PdfPageFormat.inch}';
    bottomController.text =
        '${widget.controller.pageFormat.marginBottom / PdfPageFormat.inch}';
    super.initState();
  }

  @override
  void dispose() {
    leftController.dispose();
    topController.dispose();
    rightController.dispose();
    bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16.0), children: [
      Row(
        children: [
          const Text('Theme:  '),
          DropdownButton<ThemeMode>(
            // Read the selected themeMode from the controller
            value: widget.controller.themeMode,
            // Call the updateThemeMode method any time the user selects a theme.
            onChanged: widget.controller.updateThemeMode,
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
      Row(
        children: [
          const Text('Cue Format:  '),
          DropdownButton<CueFormat>(
            value: widget.controller.cueFormat,
            onChanged: widget.controller.changeCueFormat,
            items: const [
              DropdownMenuItem(
                value: CueFormat.singleLine,
                child: Text('Single Line'),
              ),
              DropdownMenuItem(
                value: CueFormat.multiLine,
                child: Text('Two Line'),
              ),
            ],
          ),
        ],
      ),
      const Divider(),
      FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: FormBuilderTextField(
                    name: 'topMargin',
                    validator: validateDouble,
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.center,
                    controller: topController,
                    decoration: const InputDecoration(labelText: 'Top:'),
                    onChanged: (value) {
                      double? newValue = double.tryParse(value ?? '');
                      if (newValue != null) {
                        widget.controller.setMargin(PrintMargins.top, newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: FormBuilderTextField(
                    name: 'leftMargin',
                    validator: validateDouble,
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.center,
                    controller: leftController,
                    decoration: const InputDecoration(labelText: 'Left:'),
                    onChanged: (value) {
                      double? newValue = double.tryParse(value ?? '');
                      if (newValue != null) {
                        widget.controller
                            .setMargin(PrintMargins.left, newValue);
                      }
                    },
                  ),
                ),
                FittedBox(
                  child: Container(
                      margin: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      width: widget.controller.pageFormat.width / 3,
                      height: widget.controller.pageFormat.height / 3,
                      child: Container(
                        color: Colors.grey.shade400,
                        margin: EdgeInsets.fromLTRB(
                          widget.controller.pageFormat.marginLeft / 3,
                          widget.controller.pageFormat.marginTop / 3,
                          widget.controller.pageFormat.marginRight / 3,
                          widget.controller.pageFormat.marginBottom / 3,
                        ),
                      )),
                ),
                SizedBox(
                  width: 75,
                  child: FormBuilderTextField(
                    name: 'rightMargin',
                    validator: validateDouble,
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.center,
                    controller: rightController,
                    decoration: const InputDecoration(labelText: 'Right:'),
                    onChanged: (value) {
                      double? newValue = double.tryParse(value ?? '');
                      if (newValue != null) {
                        widget.controller
                            .setMargin(PrintMargins.right, newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: FormBuilderTextField(
                    name: 'bottomMargin',
                    validator: validateDouble,
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.center,
                    controller: bottomController,
                    decoration: const InputDecoration(labelText: 'Bottom:'),
                    onChanged: (value) {
                      double? newValue = double.tryParse(value ?? '');
                      if (newValue != null) {
                        widget.controller
                            .setMargin(PrintMargins.bottom, newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
