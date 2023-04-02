import 'dart:io';

import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/navigation.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

import '../../../data/show_model.dart';
import '../../../settings/settings_view.dart';
import '../../preferences/app_settings_view.dart';
import '../../printing/pdf_preview_screen.dart';

class SpotTabView extends StatelessWidget {
  const SpotTabView(
      {super.key, required this.spotCount, required this.settings});

  final SettingsController settings;
  final int spotCount;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, model, child) {
        return DefaultTabController(
          length: model.show.spotList.length,
          child: Builder(
            builder: (BuildContext context) {
              final TabController tabController =
                  DefaultTabController.of(context);

              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    navigateNewCue(context,
                        model.show.spotList[tabController.index].number);
                  },
                  child: const Icon(Icons.add),
                ),
                appBar: AppBar(
                  title: Text(model.show.info.title),
                  centerTitle: true,
                  elevation: 8,
                  actions: [
                    if (Platform.isAndroid || Platform.isIOS)
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.restorablePushNamed(
                              context, SettingsView.routeName);
                        },
                      ),
                    if (Platform.isAndroid || Platform.isIOS)
                      IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: () {
                          Navigator.restorablePushNamed(
                              context, PdfPreviewScreen.routeName);
                        },
                      ),
                  ],
                  bottom: TabBar(
                    tabs: model.show.spotList
                        .map((spot) => Tab(
                              text: 'Spot ${spot.number}',
                            ))
                        .toList(),
                  ),
                ),
                body: TabBarView(
                  controller: tabController,
                  children: List.generate(
                    spotCount,
                    (spotIndex) => ListView.builder(
                      key: PageStorageKey('myListView$spotIndex'),
                      padding: const EdgeInsets.all(24),
                      itemCount: model.usedNumbers.length,
                      itemBuilder: (BuildContext context, int cueIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: model.getCueCard(
                                  spotIndex, model.usedNumbers[cueIndex]),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
