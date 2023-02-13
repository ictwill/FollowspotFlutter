import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:followspot_application_1/src/screens/pdf_preview_screen.dart';
import 'package:followspot_application_1/src/settings/settings_controller.dart';
import 'package:followspot_application_1/src/settings/settings_view.dart';

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

  const MyMenuBar({required this.settings, super.key});

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
      MenuEntry(
        label: 'File',
        menuChildren: <MenuEntry>[
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
}
