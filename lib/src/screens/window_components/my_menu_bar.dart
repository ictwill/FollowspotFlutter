import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/cue.dart';
import '../../models/show_model.dart';
import '../../settings/settings_controller.dart';
import '../../settings/settings_view.dart';
import '../navigation.dart';
import '../preferences/maneuver_edit_view.dart';
import '../preferences/show_info_edit_view.dart';
import '../preferences/spot_color_edit_view.dart';
import '../printing/pdf_preview_screen.dart';

final _digitKeys = {
  1: LogicalKeyboardKey.digit1,
  2: LogicalKeyboardKey.digit2,
  3: LogicalKeyboardKey.digit3,
  4: LogicalKeyboardKey.digit4,
  5: LogicalKeyboardKey.digit5,
  6: LogicalKeyboardKey.digit6,
  7: LogicalKeyboardKey.digit7,
  8: LogicalKeyboardKey.digit8,
  9: LogicalKeyboardKey.digit9,
};

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
      if (selection.label == 'divider') {
        return const PopupMenuDivider();
      } else if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(
            selection.label,
          ),
        );
      } else {
        return MenuItemButton(
          shortcut: selection.shortcut,
          onPressed: selection.onPressed,
          child: Text(
            selection.label,
          ),
        );
      }
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

  const MyMenuBar({
    required this.settings,
    super.key,
  });

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
    return Consumer<ShowModel>(builder: (context, showModel, child) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: MenuBar(
              children: MenuEntry.build(_getMenus(showModel: showModel)),
            ),
          ),
        ],
      );
    });
  }

  List<MenuEntry> _getMenus({required ShowModel showModel}) {
    const menuDivider = MenuEntry(label: 'divider');

    final List<MenuEntry> result = <MenuEntry>[
      //File Menu
      MenuEntry(
        label: 'File',
        menuChildren: <MenuEntry>[
          //New Show
          MenuEntry(
            label: 'New Show',
            onPressed: () {
              showModel.newShow();
              debugPrint('New Show selected');
            },
            // shortcut: const SingleActivator(LogicalKeyboardKey.keyN,
            //     control: true, shift: true),
          ),
          menuDivider,
          //Open File
          MenuEntry(
            label: 'Open',
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  lockParentWindow: true,
                  allowMultiple: false,
                  dialogTitle: 'Open a Show File',
                  allowedExtensions: ['spot', 'fws']);
              if (result != null) {
                showModel.openShow(result.files.single.path!);
              }
              debugPrint('Open File selected');
            },
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyO, control: true),
          ),
          MenuEntry(
            label: 'Open Recent...',
            menuChildren: widget.settings.recentFiles.reversed
                .map(
                  (e) => MenuEntry(
                    label: e,
                    onPressed: () async {
                      showModel.openShow(e);
                    },
                  ),
                )
                .toList(),
          ),
          //Save File
          if (showModel.show.filename != null &&
              showModel.show.filename!.isNotEmpty)
            MenuEntry(
              label: 'Save',
              onPressed: () async {
                if (showModel.show.filename != null) {
                  showModel.save(showModel.show.filename!);
                  widget.settings.addRecentFile(showModel.show.filename!);
                } else {
                  showModel.saveAs();
                }
              },
              shortcut:
                  const SingleActivator(LogicalKeyboardKey.keyS, control: true),
            )
          else
            const MenuEntry(label: 'Save'),
          //Save as
          if (showModel.show.info.title.isNotEmpty ||
              showModel.show.spotList.isNotEmpty)
            MenuEntry(
              label: 'Save As..',
              onPressed: () async {
                showModel.saveAs();
              },
              shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
                  control: true, shift: true),
            )
          else
            const MenuEntry(label: 'Save As..'),
          const MenuEntry(label: 'divider'),
          //Print Preview
          if (showModel.show.spotList.isNotEmpty)
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
            )
          else
            const MenuEntry(label: 'Print Preview'),
          menuDivider,
          // About
          MenuEntry(
            label: 'About',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Followspot',
                applicationVersion: '1.0.0',
              );
              setState(() {
                _lastSelection = 'About';
              });
            },
          ),
          if (showModel.show.info.title.isNotEmpty ||
              showModel.show.spotList.isNotEmpty)
            MenuEntry(
                label: 'Close Show',
                onPressed: () {
                  showModel.closeShow();
                })
          else
            const MenuEntry(label: 'Close Show'),
          MenuEntry(
              label: 'Dummy Show',
              onPressed: () {
                showModel.getDummyShow();
              }),
        ],
      ),
      MenuEntry(
        label: 'Edit',
        menuChildren: <MenuEntry>[
          MenuEntry(label: 'New Cue', menuChildren: [
            for (var i = 1; i <= showModel.show.spotList.length; i++)
              if (i <= 9)
                MenuEntry(
                  label: 'Spot $i',
                  shortcut: SingleActivator(_digitKeys[i]!, control: true),
                  onPressed: () {
                    showModel.currentCue = Cue(id: 'blank', spot: i);
                    navigateNewCue(context, i);
                  },
                )
              else
                MenuEntry(
                  label: 'Spot $i',
                  onPressed: () {
                    showModel.currentCue = Cue(id: 'blank', spot: i);
                    navigateNewCue(context, i);
                  },
                )
          ]),
          menuDivider,
          MenuEntry(
            label: 'Maneuvers',
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, ManeuverEditView.routeName);

              setState(() {
                _lastSelection = 'Maneuvers';
              });
            },
            shortcut: const SingleActivator(LogicalKeyboardKey.keyM,
                control: true, shift: true),
          ),
          MenuEntry(
            label: 'Gel Frames',
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, SpotColorEditView.routeName);

              setState(() {
                _lastSelection = 'SpotColorEditView';
              });
            },
          ),
          MenuEntry(
            label: 'Show Info',
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, ShowInfoEditView.routeName);

              setState(() {
                _lastSelection = 'ShowInfoEditView';
              });
            },
          ),
          menuDivider,
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
                shortcut: const SingleActivator(LogicalKeyboardKey.keyL,
                    control: true),
              ),
              MenuEntry(
                label: 'Dark Theme',
                onPressed: () {
                  widget.settings.updateThemeMode(ThemeMode.dark);
                  setState(() {
                    _lastSelection = 'Dark Theme';
                  });
                },
                shortcut: const SingleActivator(LogicalKeyboardKey.keyD,
                    control: true),
              ),
              MenuEntry(
                label: 'System Theme',
                onPressed: () {
                  widget.settings.updateThemeMode(ThemeMode.system);
                  setState(() {
                    _lastSelection = 'Print Theme';
                  });
                },
                shortcut: const SingleActivator(LogicalKeyboardKey.keyT,
                    control: true),
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
