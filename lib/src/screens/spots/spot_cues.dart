import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/show_model.dart';
import 'cue_card.dart';

class SpotCues extends StatelessWidget {
  const SpotCues({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
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
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Consumer<ShowModel>(
          builder: (context, showModel, child) => ListView.builder(
            restorationId: 'spotListView',
            itemCount: showModel.usedNumbers.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (BuildContext context, int index) {
              final number = showModel.usedNumbers[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < showModel.show.spotList.length; i++)
                    showModel.getCueCard(i, number)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
