import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/show_model.dart';
import '../../models/cue.dart';
import '../navigation.dart';

class SpotTabs extends StatelessWidget {
  const SpotTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, showModel, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < showModel.show.spotList.length; i++)
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: ElevatedButton(
                  autofocus: true,
                  onPressed: () {
                    showModel.currentCue = Cue(id: 'blank', spot: i + 1);
                    navigateNewCue(context, i + 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text(
                          'Spot ${i + 1}',
                          textScaleFactor: 1.7,
                        ),
                        const Text('Add Cue'),
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
