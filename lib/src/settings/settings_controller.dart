import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

import '../screens/printing/pdf_preview_screen.dart';
import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  late List<String> _recentFiles;
  List<String> get recentFiles => _recentFiles;

  late PdfPageFormat _pageFormat;
  PdfPageFormat get pageFormat => _pageFormat;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.loadThemeMode();
    _recentFiles = await _settingsService.loadRecentFileList();
    _pageFormat = await _settingsService.loadPageFormat();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode != null && newThemeMode != _themeMode) {
      _themeMode = newThemeMode;
      _settingsService.saveThemeMode(newThemeMode);
    } else {
      return;
    }

    notifyListeners();
  }

  Future<void> addRecentFile(String path) async {
    List<String> files = _recentFiles.toList();
    files.remove(path);
    files.add(path);
    _recentFiles = files;

    _settingsService.saveRecentFileList(_recentFiles);
    notifyListeners();
  }

  Future<void> changePageFormat(PdfPageFormat format) async {
    _pageFormat = format;
    notifyListeners();
  }

  Future<void> setMargin(PrintMargins printMargins, double size) async {
    double value = size * PdfPageFormat.inch;

    switch (printMargins) {
      case PrintMargins.top:
        _pageFormat = _pageFormat.copyWith(marginTop: value);
        break;
      case PrintMargins.left:
        _pageFormat = _pageFormat.copyWith(marginLeft: value);
        break;
      case PrintMargins.right:
        _pageFormat = _pageFormat.copyWith(marginRight: value);
        break;
      default:
        _pageFormat = _pageFormat.copyWith(marginBottom: value);
    }

    _settingsService.savePageFormat(_pageFormat);
    notifyListeners();
  }
}
