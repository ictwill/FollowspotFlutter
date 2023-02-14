import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/show_model.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ShowModel>(
        builder: (context, showModel, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: showModel.show.spotList
                .map((e) => Text('Spot ${e.number} : ${e.cues.length} cues'))
                .toList()),
      ),
    );
  }
}
