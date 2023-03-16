import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/screens/navigation.dart';
import 'package:provider/provider.dart';

import '../../data/show_model.dart';

class SpotTabView extends StatelessWidget {
  const SpotTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(builder: (context, model, child) {
      return DefaultTabController(
        length: model.show.spotList.length,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigateNewCue(
                    context, model.show.spotList[tabController.index].number);
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              bottom: TabBar(
                tabs: model.show.spotList
                    .map((spot) => Tab(
                          text: 'Spot ${spot.number}',
                        ))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: model.show.spotList.map((spot) {
                return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: model.usedNumbers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: model.getCueCard(
                                spot.number - 1, model.usedNumbers[index]),
                          ),
                        ],
                      );
                    });
              }).toList(),
            ),
          );
        }),
      );
    });
  }
}
