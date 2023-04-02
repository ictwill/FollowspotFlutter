import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/preferences/app_settings_view.dart';
import 'package:followspot_application_1/src/screens/preferences/maneuver_edit_view.dart';
import 'package:followspot_application_1/src/screens/preferences/show_info_edit_view.dart';
import 'package:followspot_application_1/src/screens/preferences/spot_color_edit_view.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';

enum SettingPages { appSettings, showinfo, spotcolor, maneuvers }

class SettingsView extends StatefulWidget {
  const SettingsView(
      {super.key, required this.settingsController, required this.tab});

  static const routeName = '/settings';
  final SettingsController settingsController;
  final int tab;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: SettingPages.values.length,
        initialIndex: widget.tab,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Settings'),
                centerTitle: true,
                elevation: 8,
                bottom: TabBar(
                  tabs: SettingPages.values
                      .map((value) => buildTab(value))
                      .toList(),
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: List.generate(
                  SettingPages.values.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: buildPages(
                        SettingPages.values[index], widget.settingsController),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Tab buildTab(SettingPages value) {
    switch (value) {
      case SettingPages.showinfo:
        return const Tab(
          text: 'Show Info',
          icon: Icon(Icons.edit_document),
        );
      case SettingPages.spotcolor:
        return const Tab(
          text: 'Spot Color',
          icon: Icon(Icons.palette),
        );
      case SettingPages.maneuvers:
        return const Tab(
          text: 'Maneuvers',
          icon: Icon(Icons.play_arrow),
        );
      default:
        return const Tab(
          text: 'App Preferences',
          icon: Icon(Icons.settings_applications),
        );
    }
  }

  Widget buildPages(SettingPages value, SettingsController controller) {
    switch (value) {
      case SettingPages.showinfo:
        return ShowInfoEditView();
      case SettingPages.spotcolor:
        return SpotColorEditView();
      case SettingPages.maneuvers:
        return const ManeuverEditView();
      default:
        return AppSettingsView(controller: controller);
    }
  }
}
