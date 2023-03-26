import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/show_model.dart';

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
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var spot in showModel.show.spotList)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        Text('Spot ${spot.number} : ${spot.cues.length} cues'),
                  )
              ],
            ),
            Text(MediaQuery.of(context).size.width.toString()),
            Text(
              showModel.message,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
