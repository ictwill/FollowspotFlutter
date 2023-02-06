import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/models/show_model.dart';
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
  final framesControl = TextEditingController();
  final notesControl = TextEditingController();

  @override
  void initState() {
    numberControl.text = deleteTrailing(widget.cue.number);
    actionControl.text = widget.cue.action;
    targetControl.text = widget.cue.target;
    timeControl.text = widget.cue.time.toString();
    sizeControl.text = widget.cue.size;
    intensityControl.text = widget.cue.intensity.toString();
    framesControl.text = widget.cue.frames.join(' + ');
    notesControl.text = widget.cue.notes;
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
    framesControl.dispose();
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
              IconButton(
                  tooltip: 'Save this cue',
                  onPressed: () {
                    final Cue newCue = Cue(
                      id: widget.cue.id,
                      number: double.parse(numberControl.text),
                      action: actionControl.text,
                      target: targetControl.text,
                      time: int.parse(timeControl.text),
                      size: sizeControl.text,
                      intensity: int.parse(intensityControl.text),
                      frames: framesControl.text.split(' + '),
                      notes: notesControl.text,
                      spot: widget.spot,
                    );
                    show.updateCue(widget.spot, widget.cue, newCue);
                    debugPrint('Saved $newCue');
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save)),
              IconButton(
                  tooltip: 'Delete this Cue',
                  onPressed: () {
                    show.deleteCue(widget.cue);
                    debugPrint('DELETED Cue id ${widget.cue.id}');
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
          body: Hero(
            tag: widget.cue.id,
            placeholderBuilder: (context, heroSize, child) => Card(),
            child: Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: numberControl,
                              decoration:
                                  const InputDecoration(labelText: 'Cue'),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: actionControl,
                                  decoration: const InputDecoration(
                                    labelText: 'Action',
                                    prefixIcon: Icon(Icons.square),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: targetControl,
                                    decoration: const InputDecoration(
                                        labelText: 'Target')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: sizeControl,
                                    decoration: const InputDecoration(
                                        labelText: 'Size')),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: intensityControl,
                                    decoration: const InputDecoration(
                                        labelText: 'Intensity'),
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: framesControl,
                                    decoration: const InputDecoration(
                                        labelText: 'Frames')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: timeControl,
                                  decoration:
                                      const InputDecoration(labelText: 'Time'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]),
                          ],
                        ),
                      )
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
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String deleteTrailing(double number) {
  var string = number.toString();
  while (string.endsWith('0') && string.contains('.0')) {
    string = dropLast(string);
    if (string.endsWith('.')) return dropLast(string);
  }
  return string;
}

String dropLast(string) => string.substring(0, string.length - 1);
