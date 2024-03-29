import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'models/show_model.dart';
import 'screens/preferences/spot_color_edit_view.dart';
import 'screens/preferences/maneuver_edit_view.dart';
import 'screens/preferences/show_info_edit_view.dart';
import 'screens/printing/pdf_preview_screen.dart';
import 'screens/spots/spot_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'styles.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'followspotapp',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: followspotAppTheme(),
          darkTheme: followspotAppThemeDark(),
          themeMode: settingsController.themeMode,
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(
                        settingsController: settingsController,
                        tab: SettingPages.appSettings.index);
                  case ManeuverEditView.routeName:
                    return SettingsView(
                        settingsController: settingsController,
                        tab: SettingPages.maneuvers.index);
                  case ShowInfoEditView.routeName:
                    return SettingsView(
                        settingsController: settingsController,
                        tab: SettingPages.showinfo.index);
                  case SpotColorEditView.routeName:
                    return SettingsView(
                        settingsController: settingsController,
                        tab: SettingPages.spotcolor.index);
                  case PdfPreviewScreen.routeName:
                    return PdfPreviewScreen(
                        show: Provider.of<ShowModel>(context).show,
                        controller: settingsController);
                  case SpotView.routeName:
                  default:
                    return SpotView(
                        key: super.key, settings: settingsController);
                }
              },
            );
          },
        );
      },
    );
  }

  ThemeData followspotAppThemeDark() {
    return ThemeData.dark().copyWith(
        textTheme: const TextTheme(
      bodyMedium: Styles.textDefault,
      labelLarge: Styles.menuTextStyle,
    ));
  }

  ThemeData followspotAppTheme() {
    return ThemeData(
        canvasColor: Colors.grey.shade200,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        textTheme: const TextTheme(
          bodyMedium: Styles.textDefault,
          labelLarge: Styles.menuTextStyle,
        ));
  }
}
