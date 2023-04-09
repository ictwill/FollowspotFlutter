import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/show_model.dart';
import '../../../settings/settings_controller.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen(
    this.settings, {
    super.key,
  });

  static const String routeName = "/";

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Open a Show or Start a New Show'),
          ),
        ),
        if (settings.recentFiles.isNotEmpty)
          Consumer<ShowModel>(
            builder: (context, model, child) {
              return Column(
                children: settings.recentFiles.reversed
                    .map(
                      (e) => ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(width: 500),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            elevation: 8,
                            child: ListTile(
                              trailing: IconButton(
                                  onPressed: () async {
                                    await settings.removeRecentFile(e);
                                  },
                                  icon: Icon(Icons.close)),
                              hoverColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                              title: Text(e.split('\\').last.split('.').first),
                              subtitle: Text(
                                e,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                model.openShow(e);
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          )
      ],
    ));
  }
}
