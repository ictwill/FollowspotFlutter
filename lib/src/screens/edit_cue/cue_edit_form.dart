import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../data/gel_colors.dart';
import '../../data/number_helpers.dart';
import '../../data/show_model.dart';
import '../../models/cue.dart';

class CueEditForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  final Cue cue;

  CueEditForm({super.key, required this.cue});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, showModel, child) {
        Cue createCue() {
          return Cue(
              id: cue.id,
              spot: cue.spot,
              number: double.tryParse(_formKey.currentState!.value['number']) ??
                  0.0,
              maneuver: showModel.currentCue.maneuver,
              target: _formKey.currentState!.value['target'],
              time: int.tryParse(_formKey.currentState!.value['time']),
              size: _formKey.currentState!.value['size'],
              intensity:
                  int.tryParse(_formKey.currentState!.value['intensity']),
              frames: _formKey.currentState!.value['frames'],
              notes: _formKey.currentState!.value['notes']);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Item Details'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    showModel.updateCue(cue.spot, cue, createCue());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
              PopupMenuButton<int>(
                onSelected: (item) {
                  switch (item) {
                    case 0:
                      showModel.deleteCue(cue);
                      debugPrint('DELETED Cue id ${cue.id}');
                      Navigator.pop(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(value: 0, child: Text('Delete')),
                ],
              ),
            ],
          ),
          body: FormBuilder(
            key: _formKey,
            child: ListView(
              children: [
                GridView(
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      maxCrossAxisExtent: 340,
                      childAspectRatio: 5),
                  children: [
                    FormBuilderTextField(
                      name: 'number',
                      decoration: const InputDecoration(label: Text('Cue #')),
                      initialValue: deleteTrailing(cue.number),
                      autofocus: true,
                    ),
                    Autocomplete<String>(
                      key: const Key('maneuvers'),
                      initialValue: TextEditingValue(text: cue.maneuver ?? ''),
                      optionsBuilder: (textEditingValue) => showModel
                          .show.maneuverList
                          .map((e) => e.name)
                          .toList()
                          .where((element) => element
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase())),
                      onSelected: (option) => showModel.currentCue.maneuver =
                          showModel.show.getManeuver(option)?.name,
                      fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) =>
                          TextField(
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(label: Text('Maneuvers')),
                        controller: textEditingController,
                        focusNode: focusNode,
                        onSubmitted: (value) => showModel.currentCue.maneuver =
                            showModel.show.getManeuver(value)?.name,
                      ),
                    ),
                    FormBuilderTextField(
                      name: 'target',
                      decoration: const InputDecoration(label: Text('Target')),
                      textCapitalization: TextCapitalization.words,
                      initialValue: cue.target,
                    ),
                    FormBuilderTextField(
                      name: 'intensity',
                      decoration: const InputDecoration(
                        label: Text('Intensity'),
                        suffixText: '%',
                      ),
                      initialValue: cue.intensity?.toString() ?? '',
                    ),
                    FormBuilderTextField(
                      name: 'size',
                      decoration: const InputDecoration(label: Text('Size')),
                      initialValue: cue.size,
                    ),
                    FormBuilderTextField(
                      name: 'time',
                      decoration: const InputDecoration(
                        label: Text('Time'),
                        suffixText: 'count',
                      ),
                      initialValue: cue.time?.toString() ?? '',
                    ),
                  ],
                ),
                FormBuilderCheckboxGroup(
                  name: 'frames',
                  wrapSpacing: 8,
                  decoration:
                      const InputDecoration(label: Text('Color Frames')),
                  options: showModel.show.spotList
                      .singleWhere((element) => element.number == cue.spot)
                      .frames
                      .map((e) => FormBuilderFieldOption(
                            value: e,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: getGelHex(e),
                                ),
                                Text(e)
                              ],
                            ),
                          ))
                      .toList(),
                  initialValue: cue.frames,
                ),
                FormBuilderTextField(
                  name: 'notes',
                  decoration: const InputDecoration(label: Text('Notes')),
                  initialValue: cue.notes,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
