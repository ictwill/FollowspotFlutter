import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/show_model.dart';
import '../../settings/settings_controller.dart';
import '../responsive/layouts/desktop_layout.dart';
import '../responsive/layouts/mobile_layout.dart';

/// Displays a list of Cues.
class SpotView extends StatelessWidget {
  const SpotView({super.key, required this.settings});

  static const routeName = '/';
  final uuid = const Uuid();
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, model, child) {
        if (Platform.isAndroid || Platform.isIOS) {
          return MobileLayout(settings: settings);
        } else {
          return DesktopLayout(settings: settings);
        }
      },
    );
  }
}
