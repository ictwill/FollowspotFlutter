import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:provider/provider.dart';

import '../models/cue.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    final Cue cue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: const EditCue(),
      ),
    );
  }
}

class EditCue extends StatelessWidget {
  const EditCue({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (BuildContext context, show, Widget? child) {
        return Table(
          children: [
            TableRow(
              children: [
                TextField(
                  controller: TextEditingController(
                    text: show.currentCue.number.toString(),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                    text: show.currentCue.action.toString(),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                    text: show.currentCue.target.toString(),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                    text: show.currentCue.size.toString(),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
