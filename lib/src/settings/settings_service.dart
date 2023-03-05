import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  // Future<PdfPageFormat> pageFormat() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final json = prefs.getString('page_format');
  //   return jsonDecode(json ?? '');
  // }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<void> updatePageFormat(PdfPageFormat pageFormat) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('page_format', jsonEncode(pageFormat));
  }
}
