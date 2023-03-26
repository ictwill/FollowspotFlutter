import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  Future<void> saveThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme.toString());
    debugPrint(theme.toString());
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('theme');

    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> savePageFormat(PdfPageFormat pageFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('page_Format', jsonEncode(pageFormat));
  }

  Future<PdfPageFormat> loadPageFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('page_format');
    PdfPageFormat format;

    if (json != null && json.isNotEmpty) {
      format = jsonDecode(json);
    } else {
      format = PdfPageFormat.letter;
    }

    return format;
  }

  Future<void> saveRecentFileList(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('files', paths);
  }

  Future<List<String>> loadRecentFileList() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('files');
    return list ?? List.empty();
  }
}
