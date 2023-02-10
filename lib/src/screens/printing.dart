import 'package:flutter/foundation.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/spots/cue_card.dart';
import 'package:followspot_application_1/src/spots/cue_edit_view.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/show.dart';

Future<Uint8List> makePdf(PdfPageFormat pageFormat, Show show) async {
  final numbers = show.cueNumbers();
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      pageFormat: pageFormat,
      header: (context) => _showHeader(show),
      build: (pw.Context context) {
        return numbers.map((e) {
          return pw.Row(
            children: [
              for (int i = 0; i < show.spotList.length; i++)
                pw.Expanded(
                  child: PrintCard(show.spotList[i].findCue(e)),
                )
            ],
          );
        }).toList();
      },
    ),
  );

  // // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
  // final output = await getTemporaryDirectory();
  // final file = File("${output.path}/example.pdf");
  // await file.writeAsBytes(await pdf.save());

  return await pdf.save();
}

pw.Column _showHeader(Show show) {
  return pw.Column(children: [
    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(show.info.ld, softWrap: false),
      pw.FittedBox(
          fit: pw.BoxFit.fitWidth,
          child: pw.Text(show.info.title, textAlign: pw.TextAlign.center)),
      pw.Text(
          '${show.info.date.year}/${show.info.date.month}/${show.info.date.day}',
          textAlign: pw.TextAlign.right),
    ]),
    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(show.info.ald, softWrap: false),
      pw.Text(show.info.location,
          softWrap: false, textAlign: pw.TextAlign.right),
      pw.Text(''),
    ]),
    pw.SizedBox(height: 12),
    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
      for (int i = 0; i < show.spotList.length; i++)
        pw.Column(children: [
          pw.Text('Spot ${show.spotList[i].number}',
              textAlign: pw.TextAlign.center),
          pw.Row(
            children: show.spotList[i].frames
                .map((e) => pw.Text(' $e ', textScaleFactor: 0.7))
                .toList(),
          )
        ])
    ])
  ]);
}

class PrintCard extends pw.StatelessWidget {
  final Cue cue;

  PrintCard(this.cue);

  @override
  pw.Widget build(pw.Context context) {
    if (cue.id == 'blank') {
      return pw.Spacer();
    } else {
      return pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        child: pw.Row(children: [
          pw.SizedBox(width: 1.0),
          pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(cue.getColor().value),
            ),
            height: 34,
            width: 32,
            alignment: pw.Alignment.center,
            child: pw.Text(deleteTrailing(cue.number),
                textAlign: pw.TextAlign.center),
          ),
          pw.Expanded(
              child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: pw.Table(children: [
                    pw.TableRow(children: [
                      pw.Text(cue.action),
                      pw.Text(cue.target, textAlign: pw.TextAlign.center),
                      pw.Text(cue.size, textAlign: pw.TextAlign.right),
                    ]),
                    pw.TableRow(children: [
                      pw.Text(validateIntensity(intensity: cue.intensity)),
                      pw.Text(cue.getFrames(), textAlign: pw.TextAlign.center),
                      pw.Text(validateTime(time: cue.time),
                          textAlign: pw.TextAlign.right),
                    ])
                  ])))
        ]),
      );
    }
  }
}
