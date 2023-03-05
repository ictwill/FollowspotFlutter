import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/maneuver.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/screens/spots/cue_card.dart';

import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class CueEditView extends StatefulWidget {
  const CueEditView(
      {super.key, required this.spot, required this.cue, this.maneuver});

  final int spot;
  final Cue cue;
  final Maneuver? maneuver;

  @override
  State<CueEditView> createState() => _CueEditViewState();
}

class _CueEditViewState extends State<CueEditView> {
  final _formKey = GlobalKey<FormBuilderState>();

  final numberControl = TextEditingController();
  final maneuverControl = TextEditingController();
  final targetControl = TextEditingController();
  final timeControl = TextEditingController();
  final sizeControl = TextEditingController();
  final intensityControl = TextEditingController();
  final notesControl = TextEditingController();
  List<String> frames = [];
  Color? color;
  Icon icon = const Icon(Icons.square);

  @override
  void initState() {
    if (widget.cue.number == 0.0) {
      numberControl.text = '';
    } else {
      numberControl.text = deleteTrailing(widget.cue.number);
    }

    maneuverControl.text = widget.cue.maneuver ?? '';
    targetControl.text = widget.cue.target;
    timeControl.text = validateTime(time: widget.cue.time);
    sizeControl.text = widget.cue.size;
    intensityControl.text = validateIntensity(intensity: widget.cue.intensity);
    notesControl.text = widget.cue.notes;

    frames.addAll(widget.cue.frames);

    if (widget.cue.maneuver != null) {
      color = widget.maneuver!.getColor();
      icon = Icon(
        IconData(widget.maneuver!.iconCodePoint ?? Icons.square.codePoint),
        color: widget.maneuver!.getColor(),
      );
    }
    debugPrint(widget.cue.toString());

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberControl.dispose();
    maneuverControl.dispose();
    targetControl.dispose();
    timeControl.dispose();
    sizeControl.dispose();
    intensityControl.dispose();
    notesControl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowModel>(
      builder: (BuildContext context, showModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Item Details'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (double.tryParse(numberControl.text) != null) {
                    showModel.updateCue(
                        widget.spot,
                        widget.cue,
                        _createCue(
                            showModel.show.getManeuver(maneuverControl.text)));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
              PopupMenuButton<int>(
                onSelected: (item) {
                  switch (item) {
                    case 0:
                      showModel.deleteCue(widget.cue);
                      debugPrint('DELETED Cue id ${widget.cue.id}');
                      Navigator.pop(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(value: 0, child: Text('Delete')),
                ],
              ),
              // TextButton(
              //   onPressed: () {
              //     show.deleteCue(widget.cue);
              //     debugPrint('DELETED Cue id ${widget.cue.id}');
              //     Navigator.pop(context);
              //   },
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.delete),
              //       SizedBox(width: 8.0),
              //       Text('Delete')
              //     ],
              //   ),
              // ),
            ],
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(16.0),
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  GridView(
                    padding: const EdgeInsets.all(8.0),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            maxCrossAxisExtent: 340,
                            childAspectRatio: 3),
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: numberControl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: validateDouble,
                        decoration: const InputDecoration(
                          labelText: 'Cue',
                          hintText: 'Enter a Number',
                        ),
                      ),
                      // Icon(
                      //   widget.cue.maneuver?.icon,
                      //   color: Color(widget.cue.maneuver?.color ?? 0xFF77777),
                      // ),
                      TextFormField(
                        autofillHints: List.from(
                            showModel.show.maneuverList.map((e) => e.name)),
                        controller: maneuverControl,
                        decoration: const InputDecoration(
                          labelText: 'Maneuver',
                        ),
                      ),
                      TextFormField(
                          controller: targetControl,
                          decoration:
                              const InputDecoration(labelText: 'Target')),
                      TextFormField(
                          controller: sizeControl,
                          decoration: const InputDecoration(labelText: 'Size')),
                      TextFormField(
                          controller: intensityControl,
                          decoration:
                              const InputDecoration(labelText: 'Intensity'),
                          textAlign: TextAlign.center),
                      TextFormField(
                          controller: timeControl,
                          decoration: const InputDecoration(labelText: 'Time'),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  Center(
                    child: Wrap(
                      spacing: 16,
                      children: showModel
                          .getFrameList(widget.cue.spot)
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: FilterChip(
                                  focusNode: FocusNode(skipTraversal: true),
                                  selectedColor: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(4.0),
                                  label: Text(
                                      '${showModel.getFrameList(widget.cue.spot).indexOf(e) + 1} : $e'),
                                  labelPadding: const EdgeInsets.all(8.0),
                                  selected: frames.contains(e),
                                  onSelected: (value) {
                                    setState(() {
                                      if (value) {
                                        frames.add(e);
                                      } else {
                                        frames.remove(e);
                                      }
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  TextFormField(
                      controller: notesControl,
                      decoration: const InputDecoration(labelText: 'Notes')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? validateDouble(value) {
    if (value != null && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return 'Invalid input';
      } else if (double.parse(value) <= 0.0) {
        return 'Must be greater than zero';
      }
    }
    return null;
  }

  Cue _createCue(Maneuver? maneuver) => Cue(
        id: widget.cue.id,
        number: double.parse(numberControl.text),
        maneuver: maneuverControl.text,
        target: targetControl.text,
        time: int.parse(timeControl.text.isNotEmpty ? timeControl.text : '-1'),
        size: sizeControl.text,
        intensity: int.parse(
            intensityControl.text.isNotEmpty ? intensityControl.text : '-1'),
        frames: frames,
        notes: notesControl.text,
        spot: widget.spot,
      );
}

String deleteTrailing(double number) {
  var string = number.toString();
  while (string.endsWith('0') && string.contains('.0')) {
    string = _dropLast(string);
    if (string.endsWith('.')) return _dropLast(string);
  }
  return string;
}

String _dropLast(string) => string.substring(0, string.length - 1);
