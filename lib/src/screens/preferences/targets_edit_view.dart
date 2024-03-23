import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/show_model.dart';

class TargetsEditView extends StatefulWidget {
  const TargetsEditView({super.key});

  static const routeName = '/settings/maneuvers';

  @override
  State<TargetsEditView> createState() => _ManeuverEditViewState();
}

class _ManeuverEditViewState extends State<TargetsEditView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (BuildContext context, model, Widget? child) {
        return SizedBox.expand(
            child: DataTable(
                columns: const [
              DataColumn(
                label: Text('Target'),
              ),
              DataColumn(
                label: Text('Delete'),
              ),
            ],
                rows: model.show.targets
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            TextField(
                              controller: TextEditingController(text: e),
                              onSubmitted: (value) {
                                model.updateTarget(e, value);
                              },
                            ),
                          ),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              model.deleteTarget(e);
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
