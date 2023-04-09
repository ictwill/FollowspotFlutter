import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../data/gel_colors.dart';
import '../../data/number_helpers.dart';
import '../../models/show_model.dart';
import '../../models/cue.dart';

class CueEditForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  final Cue cue;

  CueEditForm({super.key, required this.cue});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (context, model, child) {
        Cue createCue() {
          List<int> frames = _formKey.currentState!.value['frames'];
          if (frames.length > 1) frames.sort();
          return Cue(
              id: cue.id,
              spot: _formKey.currentState!.value['spot'],
              number: double.tryParse(_formKey.currentState!.value['number']) ??
                  0.0,
              maneuver: cue.maneuver,
              target: _formKey.currentState!.value['target'],
              time: int.tryParse(_formKey.currentState!.value['time']),
              size: _formKey.currentState!.value['size'],
              intensity:
                  int.tryParse(_formKey.currentState!.value['intensity']),
              frames: frames,
              notes: _formKey.currentState!.value['notes']);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Item Details'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    model.updateCue(cue, createCue());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
              PopupMenuButton<int>(
                onSelected: (item) {
                  switch (item) {
                    case 0:
                      model.deleteCue(cue);
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
                    FormBuilderDropdown(
                      decoration: const InputDecoration(labelText: 'Spot'),
                      name: 'spot',
                      items: model.show.spotList
                          .map((e) => DropdownMenuItem(
                              value: e.number,
                              child: Text(e.number.toString())))
                          .toList(),
                      initialValue: cue.spot,
                    ),
                    FormBuilderTextField(
                      name: 'number',
                      validator: validateDouble,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: const InputDecoration(label: Text('Cue #')),
                      initialValue: deleteTrailing(cue.number),
                      autofocus: true,
                    ),
                    Autocomplete<String>(
                      key: const Key('maneuvers'),
                      initialValue: TextEditingValue(text: cue.maneuver ?? ''),
                      optionsBuilder: (textEditingValue) => model
                          .show.maneuverList
                          .map((e) => e.name)
                          .toList()
                          .where((element) => element
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase())),
                      onSelected: (option) =>
                          cue.maneuver = model.show.getManeuver(option)?.name,
                      fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) =>
                          TextField(
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(label: Text('Maneuvers')),
                        controller: textEditingController,
                        focusNode: focusNode,
                        onSubmitted: (value) =>
                            cue.maneuver = model.show.getManeuver(value)?.name,
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
                  options: model
                      .getFrameList(cue.spot)
                      .entries
                      .map((entry) => FormBuilderFieldOption(
                            value: entry.key,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: getGelHex(entry.value),
                                ),
                                Text(entry.value)
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
