import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/settings/cue_formats.dart';
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
    await prefs.setDouble('page_width', pageFormat.width);
    await prefs.setDouble('page_height', pageFormat.height);
    await prefs.setDouble('margin_left', pageFormat.marginLeft);
    await prefs.setDouble('margin_top', pageFormat.marginTop);
    await prefs.setDouble('margin_right', pageFormat.marginRight);
    await prefs.setDouble('margin_bottom', pageFormat.marginBottom);
  }

  Future<PdfPageFormat> loadPageFormat() async {
    final prefs = await SharedPreferences.getInstance();

    PdfPageFormat format = PdfPageFormat(
      prefs.getDouble('page_width') ?? PdfPageFormat.letter.width,
      prefs.getDouble('page_height') ?? PdfPageFormat.letter.height,
      marginLeft: prefs.getDouble('margin_left') ?? 0.0,
      marginTop: prefs.getDouble('margin_top') ?? 0.0,
      marginRight: prefs.getDouble('margin_right') ?? 0.0,
      marginBottom: prefs.getDouble('margin_bottom') ?? 0.0,
    );

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

  Future<void> saveCueformat(CueFormat cueFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cueformat', cueFormat.toString());
    debugPrint(cueFormat.toString());
  }

  Future<CueFormat> loadCueformat() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('cueformat');

    switch (value) {
      case 'CueFormats.singleLine':
        return CueFormat.singleLine;
      case 'CueFormats.twoLine':
        return CueFormat.multiLine;
      default:
        return CueFormat.multiLine;
    }
  }
}
