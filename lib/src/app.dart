import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/screens/maneuver_edit_view.dart';
import 'package:followspot_application_1/src/screens/pdf_preview_screen.dart';
import 'package:provider/provider.dart';

import 'screens/spots/spot_color_edit_view.dart';
import 'screens/spots/spot_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

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
          theme: ThemeData(
              canvasColor: Colors.grey.shade200,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)
                  .copyWith(secondary: Colors.amber)),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case PdfPreviewScreen.routeName:
                    return PdfPreviewScreen(
                        show: Provider.of<ShowModel>(context).show,
                        controller: settingsController);
                  case ManeuverEditView.routeName:
                    return const ManeuverEditView();
                  case SpotColorEditView.routeName:
                    return SpotColorEditView();
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
}
