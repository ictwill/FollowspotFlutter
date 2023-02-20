import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:provider/provider.dart';

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
                              e.icon,
                              color: Color(e.color),
                            ),
                            onTap: () {
                              //TODO: Implement Icon Picker
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
                                              showModel.updateManeuver(
                                                  pickerColor, e);
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
                        ],
                      ),
                    )
                    .toList())),
      ),
    );
  }
}
