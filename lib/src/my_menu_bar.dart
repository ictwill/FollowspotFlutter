import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:followspot_application_1/src/screens/pdf_preview_screen.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:followspot_application_1/src/settings/settings_view.dart';
import 'package:uuid/uuid.dart';

import 'models/cue.dart';
import 'spots/cue_edit_view.dart';

/// A class for consolidating the definition of menu entries.
///
/// This sort of class is not required, but illustrates one way that defining
/// menus could be done.
class MenuEntry {
  const MenuEntry(
      {required this.label, this.shortcut, this.onPressed, this.menuChildren})
      : assert(menuChildren == null || onPressed == null,
            'onPressed is ignored if menuChildren are provided');
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(selection.label),
        );
      }
      return MenuItemButton(
        shortcut: selection.shortcut,
        onPressed: selection.onPressed,
        child: Text(selection.label),
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
      List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result =
        <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}

class MyMenuBar extends StatefulWidget {
  final SettingsController settings;
  final int spots;

  const MyMenuBar({required this.settings, super.key, required this.spots});

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  ShortcutRegistryEntry? _shortcutsEntry;
  String? _lastSelection;

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: MenuBar(
            children: MenuEntry.build(_getMenus()),
          ),
        ),
      ],
    );
  }

  List<MenuEntry> _getMenus() {
    final List<MenuEntry> result = <MenuEntry>[
      //File Menu
      MenuEntry(
        label: 'File',
        menuChildren: <MenuEntry>[
          //New Show
          MenuEntry(
            label: 'New Show',
            onPressed: () {
              debugPrint('New Show selected');
            },
            shortcut: const SingleActivator(LogicalKeyboardKey.keyN,
                control: true, shift: true),
          ),
          //Open File
          MenuEntry(
            label: 'Open',
            onPressed: () {
              debugPrint('Open File selected');
            },
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyO, control: true),
          ),
          //Save File
          MenuEntry(
            label: 'Save',
            onPressed: () {
              debugPrint('Save Show to previous file');
            },
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyS, control: true),
          ),
          //Save as
          MenuEntry(
            label: 'Save As..',
            onPressed: () {
              debugPrint('Save asselected');
            },
            shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
                control: true, shift: true),
          ),
          //Print Preview
          MenuEntry(
            label: 'Print Preview',
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, PdfPreviewScreen.routeName);
              setState(() {
                _lastSelection = 'About';
              });
            },
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyP, control: true),
          ),
          // About
          MenuEntry(
            label: 'About',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'MenuBar Sample',
                applicationVersion: '1.0.0',
              );
              setState(() {
                _lastSelection = 'About';
              });
            },
          ),
        ],
      ),
      MenuEntry(
        label: 'Edit',
        menuChildren: <MenuEntry>[
          MenuEntry(label: 'New Cue', menuChildren: [
            if (widget.spots > 0)
              MenuEntry(
                label: 'Spot 1',
                shortcut: const SingleActivator(LogicalKeyboardKey.digit1,
                    control: true),
                onPressed: () => navigateNewCue(context, 1),
              ),
            if (widget.spots > 1)
              MenuEntry(
                label: 'Spot 2',
                shortcut: const SingleActivator(LogicalKeyboardKey.digit2,
                    control: true),
                onPressed: () => navigateNewCue(context, 2),
              ),
            if (widget.spots > 2)
              MenuEntry(
                label: 'Spot 3',
                shortcut: const SingleActivator(LogicalKeyboardKey.digit3,
                    control: true),
                onPressed: () => navigateNewCue(context, 3),
              ),
            if (widget.spots > 3)
              MenuEntry(
                label: 'Spot 4',
                shortcut: const SingleActivator(LogicalKeyboardKey.digit4,
                    control: true),
                onPressed: () => navigateNewCue(context, 4),
              ),
          ]),
          MenuEntry(
            label: 'Settings',
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);

              setState(() {
                _lastSelection = 'Settings';
              });
            },
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyW, control: true),
          ),
          MenuEntry(
            label: 'Theme',
            menuChildren: <MenuEntry>[
              MenuEntry(
                label: 'Light Theme',
                onPressed: () {
                  widget.settings.updateThemeMode(ThemeMode.light);
                  setState(() {
                    _lastSelection = 'Light Theme';
                  });
                },
                // shortcut: const SingleActivator(LogicalKeyboardKey.keyR,
                //     control: true),
              ),
              MenuEntry(
                label: 'Dark Theme',
                onPressed: () {
                  widget.settings.updateThemeMode(ThemeMode.dark);
                  setState(() {
                    _lastSelection = 'Dark Theme';
                  });
                },
                // shortcut: const SingleActivator(LogicalKeyboardKey.keyG,
                //     control: true),
              ),
              MenuEntry(
                label: 'System Theme',
                onPressed: () {
                  widget.settings.updateThemeMode(ThemeMode.system);
                  setState(() {
                    _lastSelection = 'Print Theme';
                  });
                },
                // shortcut: const SingleActivator(LogicalKeyboardKey.keyB,
                //     control: true),
              ),
            ],
          ),
        ],
      ),
    ];
    // (Re-)register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application, and update them if they've changed.
    _shortcutsEntry?.dispose();
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }

  Future<dynamic> navigateNewCue(BuildContext context, int spot) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CueEditView(
              spot: spot, cue: Cue(id: const Uuid().v4(), spot: spot));
        },
      );
}
