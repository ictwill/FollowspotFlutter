import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

import '../../data/show_model.dart';

class ManeuverEditView extends StatefulWidget {
  const ManeuverEditView({super.key});

  static const routeName = '/maneuvers';

  @override
  State<ManeuverEditView> createState() => _ManeuverEditViewState();
}

class _ManeuverEditViewState extends State<ManeuverEditView> {
  Color pickerColor = Colors.grey;

  void _changeColor(Color color) => setState(() => pickerColor = color);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (BuildContext context, showModel, Widget? child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Maneuvers'),
        ),
        body: SizedBox.expand(
            child: DataTable(
                columns: const [
              DataColumn(
                label: Text('Maneuver'),
              ),
              DataColumn(
                label: Text('Icon'),
              ),
              DataColumn(
                label: Text('Color'),
              ),
              DataColumn(
                label: Text('Delete'),
              ),
            ],
                rows: showModel.show.maneuverList
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(e.name),
                            onTap: () {
                              //TODO: Implement TextField Editing when selected
                            },
                          ),
                          DataCell(
                            Icon(
                              IconData(
                                  e.iconCodePoint ?? Icons.square.codePoint,
                                  fontFamily: e.fontFamily),
                              color: Color(e.color),
                            ),
                            onTap: () async {
                              IconData? iconData =
                                  await FlutterIconPicker.showIconPicker(
                                      context);
                              if (iconData != null) {
                                showModel.updateManeuverIcon(e, iconData);
                              }
                            },
                          ),
                          DataCell(
                            Icon(
                              Icons.palette,
                              color: Color(e.color),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Select a Color'),
                                        content: MaterialPicker(
                                            pickerColor: Color(e.color),
                                            onColorChanged: _changeColor,
                                            enableLabel: true,
                                            portraitOnly: true),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              showModel.updateManeuverColor(
                                                  e, pickerColor);
                                              Navigator.pop(context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Okay'),
                                            ),
                                          )
                                        ],
                                      ));
                            },
                          ),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showModel.deleteManeuver(e);
                            },
                          ))
                        ],
                      ),
                    )
                    .toList())),
      ),
    );
  }
}
