import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/navigation.dart';
import 'package:provider/provider.dart';

import '../../models/show_model.dart';

class SpotCues extends StatelessWidget {
  const SpotCues({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, model, child) {
        return DefaultTabController(
          length: model.show.spotList.length,
          child: Builder(builder: (context) {
            final TabController tabController =
                DefaultTabController.of(context);
            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  onTap: (value) {
                    navigateNewCue(context, model.show.spotList[value].number);
                  },
                  controller: tabController,
                  tabs: model.show.spotList
                      .map((spot) => Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Spot ${spot.number}',
                                    textAlign: TextAlign.center),
                                const SizedBox(width: 16),
                                const Icon(Icons.add)
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              body: ShaderMask(
                shaderCallback: (Rect rect) {
                  return _fadeTopBottom(context).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView.builder(
                  restorationId: 'spotListView',
                  itemCount: model.usedNumbers.length,
                  padding: const EdgeInsets.all(24.0),
                  itemBuilder: (BuildContext context, int index) {
                    final number = model.usedNumbers[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < model.show.spotList.length; i++)
                          Expanded(
                              child: Column(
                                  children: model.getCueCards(i, number)))
                      ],
                    );
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

LinearGradient _fadeTopBottom(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Theme.of(context).canvasColor,
      Colors.transparent,
      Colors.transparent,
      Theme.of(context).canvasColor,
    ],
    stops: const [0.0, 0.025, 0.975, 1.0],
  );
}
