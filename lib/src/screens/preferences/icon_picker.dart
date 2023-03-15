import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const List<String> _iconNames = <String>[
  'add',
  'aperature-closed',
  'arrow-down',
  'arrow-up-circle',
  'arrow-up',
  'arrows-double-cw',
  'arrows-up-down',
  'cancel',
  'check',
  'circular-arrows-inv',
  'color-palette',
  'dash',
  'double-arrows-broken',
  'double-arrows-linked',
  'forbidden',
  'group',
  'logo',
  'menu',
  'more-vertical',
  'save',
  'settings',
  'stop-dash',
  'stop',
  'two-circles'
];

class IconPicker extends StatelessWidget {
  const IconPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: _iconNames
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, e);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset('assets/images/$e.svg',
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          semanticsLabel: 'A red up arrow'),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
