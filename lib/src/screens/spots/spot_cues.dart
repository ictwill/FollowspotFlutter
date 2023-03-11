import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/show_model.dart';

class SpotCues extends StatelessWidget {
  const SpotCues({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return _fadeTopBottom(context).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: _buildCueList(),
      ),
    );
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

  Consumer<ShowModel> _buildCueList() {
    return Consumer<ShowModel>(
      builder: (context, showModel, child) {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 960) {
            return _buildMatchedMultiList(showModel);
          } else {
            return _buildSingleCueList(showModel);
          }
        });
      },
    );
  }

  ListView _buildSingleCueList(ShowModel showModel) {
    return ListView.builder(
      itemCount: showModel.usedNumbers.length,
      padding: const EdgeInsets.all(12.0),
      itemBuilder: (BuildContext context, int index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showModel.getCueCard(0, showModel.usedNumbers[index]),
          ],
        );
      },
    );
  }

  ListView _buildMatchedMultiList(ShowModel showModel) {
    return ListView.builder(
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
    );
  }
}
