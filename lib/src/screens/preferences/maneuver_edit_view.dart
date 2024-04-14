import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:followspot_application_1/src/screens/preferences/icon_picker.dart';
import 'package:provider/provider.dart';

import '../../models/show_model.dart';

class ManeuverEditView extends StatefulWidget {
  const ManeuverEditView({super.key});

  static const routeName = '/settings/maneuvers';

  @override
  State<ManeuverEditView> createState() => _ManeuverEditViewState();
}

class _ManeuverEditViewState extends State<ManeuverEditView> {
  Color pickerColor = Colors.grey;

  void _changeColor(Color color) => setState(() => pickerColor = color);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (BuildContext context, model, Widget? child) {
        return SizedBox.expand(
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
                label: Text('Header'),
              ),
              DataColumn(
                label: Text('Delete'),
              ),
            ],
                rows: model.show.maneuverList
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            TextField(
                              controller: TextEditingController(text: e.name),
                              onSubmitted: (value) {
                                model.updateManeuverName(e, value);
                              },
                            ),
                          ),
                          DataCell(
                            Icon(
                              IconData(
                                  e.iconCodePoint ?? Icons.square.codePoint,
                                  fontFamily: e.fontFamily),
                              color: Color(e.color),
                            ),
                            onTap: () async {
                              IconData result = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Select an Icon'),
                                        content: IconPicker(
                                            iconColor: Color(e.color)),
                                      ));
                              print(result);
                              model.updateManeuverIcon(e, result);
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
                                              model.updateManeuverColor(
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
                          DataCell(Checkbox(
                            value: e.header,
                            onChanged: ((newvalue) {
                              setState(() {
                                model.toggleHeader(e, newvalue ?? false);
                              });
                            }),
                          )),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              model.deleteManeuver(e);
                            },
                          )),
                        ],
                      ),
                    )
                    .toList()));
      },
    );
  }
}
