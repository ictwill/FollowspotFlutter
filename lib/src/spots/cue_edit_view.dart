import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
import 'package:followspot_application_1/src/spots/cue_card.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class CueEditView extends StatefulWidget {
  const CueEditView({super.key, required this.spot, required this.cue});

  final int spot;
  final Cue cue;

  @override
  State<CueEditView> createState() => _CueEditViewState();
}

class _CueEditViewState extends State<CueEditView> {
  final numberControl = TextEditingController();
  final actionControl = TextEditingController();
  final targetControl = TextEditingController();
  final timeControl = TextEditingController();
  final sizeControl = TextEditingController();
  final intensityControl = TextEditingController();
  final notesControl = TextEditingController();
  List<String> frames = [];

  @override
  void initState() {
    numberControl.text = deleteTrailing(widget.cue.number);
    actionControl.text = widget.cue.action;
    targetControl.text = widget.cue.target;
    timeControl.text = validateTime(time: widget.cue.time);
    sizeControl.text = widget.cue.size;
    intensityControl.text = validateIntensity(intensity: widget.cue.intensity);
    notesControl.text = widget.cue.notes;

    frames.addAll(widget.cue.frames);

    debugPrint(widget.cue.toString());
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberControl.dispose();
    actionControl.dispose();
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
      builder: (BuildContext context, show, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Item Details'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  show.updateCue(widget.spot, widget.cue, _createCue());
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
              PopupMenuButton<int>(
                onSelected: (item) {
                  switch (item) {
                    case 0:
                      show.deleteCue(widget.cue);
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
          body: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: numberControl,
                            decoration: const InputDecoration(labelText: 'Cue'),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: actionControl,
                          decoration: const InputDecoration(
                            labelText: 'Action',
                            prefixIcon: Icon(Icons.square),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: targetControl,
                            decoration:
                                const InputDecoration(labelText: 'Target')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: sizeControl,
                            decoration:
                                const InputDecoration(labelText: 'Size')),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(''),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: intensityControl,
                            decoration:
                                const InputDecoration(labelText: 'Intensity'),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: show
                                .getFrameList(widget.cue)
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FilterChip(
                                        label: Text(e),
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
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: timeControl,
                          decoration: const InputDecoration(labelText: 'Time'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                            controller: notesControl,
                            decoration:
                                const InputDecoration(labelText: 'Notes')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Cue _createCue() {
    final Cue newCue = Cue(
      id: widget.cue.id,
      number: double.parse(numberControl.text),
      action: actionControl.text,
      target: targetControl.text,
      time: int.parse(timeControl.text),
      size: sizeControl.text,
      intensity: int.parse(intensityControl.text),
      frames: frames,
      notes: notesControl.text,
      spot: widget.spot,
    );
    return newCue;
  }
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
