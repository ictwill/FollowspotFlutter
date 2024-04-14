import 'package:flutter/material.dart';

import 'icon_names.dart';

class IconPicker extends StatelessWidget {
  final Color iconColor;

  const IconPicker({super.key, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: iconNames.entries
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, e.key);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        IconData(e.key),
                        color: iconColor,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
