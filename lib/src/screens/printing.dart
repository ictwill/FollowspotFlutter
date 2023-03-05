import 'package:flutter/services.dart';
import 'package:followspot_application_1/src/models/cue.dart';
import 'package:followspot_application_1/src/screens/spots/cue_card.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../models/maneuver.dart';
import '../models/show.dart';

Future<Uint8List> makePdf(
    PdfPageFormat pageFormat, Show show, int indexSpot) async {
  final pageTheme = await myPageTheme(pageFormat);

  final numbers = show.cueNumbers();
  final pdf = Document();
  pdf.addPage(
    MultiPage(
      pageTheme: pageTheme,
      header: (context) => _showHeader(show: show, indexSpot: indexSpot),
      footer: (Context context) {
        return Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) {
        return numbers.map((e) {
          return Row(
            children: [
              if (indexSpot == -1)
                for (int i = 0; i < show.spotList.length; i++)
                  Expanded(
                    child: PrintCompactCard(show.spotList[i].findCue(e),
                        show.getManeuver(show.spotList[i].findCue(e).maneuver)),
                  )
              else
                Expanded(
                  child: PrintWideCard(
                      show.spotList[indexSpot].findCue(e),
                      show.getManeuver(
                          show.spotList[indexSpot].findCue(e).maneuver)),
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

Column _showHeader({required Show show, required int indexSpot}) {
  return Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(show.info.ld, softWrap: false),
      FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(show.info.title, textAlign: TextAlign.center)),
      Text(
          '${show.info.date.year}/${show.info.date.month}/${show.info.date.day}',
          textAlign: TextAlign.right),
    ]),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(show.info.ald, softWrap: false),
      Text(show.info.location, softWrap: false, textAlign: TextAlign.right),
      Text(''),
    ]),
    SizedBox(height: 12),
    Divider(thickness: .1),
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      if (indexSpot == -1)
        for (int i = 0; i < show.spotList.length; i++) spotHeader(show, i)
      else
        spotHeader(show, indexSpot)
    ]),
    Divider(thickness: .1),
  ]);
}

Column spotHeader(Show show, int i) {
  return Column(children: [
    Text('Spot ${show.spotList[i].number}', textAlign: TextAlign.center),
    Row(
      children: show.spotList[i].frames
          .map((e) => Text(' $e ', textScaleFactor: 0.7))
          .toList(),
    ),
  ]);
}

///Card Printable Widget for a cue in a column
class PrintCompactCard extends StatelessWidget {
  final Cue cue;
  final Maneuver? maneuver;

  PrintCompactCard(this.cue, this.maneuver);
  @override
  Widget build(Context context) {
    if (cue.id == 'blank') {
      return Spacer();
    } else {
      return Container(
        decoration: BoxDecoration(border: Border.all(width: .1)),
        child: Row(children: [
          SizedBox(width: 1.0),
          Container(
            decoration: BoxDecoration(
              color: PdfColor.fromInt(maneuver?.color ?? 0xFF777777),
            ),
            height: 34,
            width: 32,
            alignment: Alignment.center,
            child:
                Text(deleteTrailing(cue.number), textAlign: TextAlign.center),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Table(children: [
              TableRow(children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  if (maneuver?.iconCodePoint != null)
                    Icon(IconData(maneuver!.iconCodePoint!),
                        color: PdfColor.fromInt(maneuver?.color ?? 0xFF77777),
                        size: 12),
                  Text(maneuver?.name ?? '-'),
                ]),
                Text(cue.target, textAlign: TextAlign.center),
                Text(cue.size, textAlign: TextAlign.right),
              ]),
              TableRow(children: [
                Text('${validateIntensity(intensity: cue.intensity)} %'),
                Text(cue.getFrames(), textAlign: TextAlign.center),
                Text('${validateTime(time: cue.time)} ct',
                    textAlign: TextAlign.right),
              ])
            ]),
          ))
        ]),
      );
    }
  }
}

///Card Printable Widget for a cue in a column
class PrintWideCard extends StatelessWidget {
  final Cue cue;
  final Maneuver? maneuver;

  PrintWideCard(this.cue, this.maneuver);

  @override
  Widget build(Context context) {
    if (cue.id == 'blank') {
      return SizedBox(height: 24);
    } else {
      return Container(
        decoration: BoxDecoration(border: Border.all(width: .1)),
        child: Row(children: [
          SizedBox(width: 1.0),
          Container(
            decoration: BoxDecoration(
              color: PdfColor.fromInt(maneuver?.color ?? 0xFF777777),
            ),
            height: 24,
            width: 32,
            alignment: Alignment.center,
            child:
                Text(deleteTrailing(cue.number), textAlign: TextAlign.center),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Table(children: [
              TableRow(children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(const IconData(0xe530),
                      color: PdfColor.fromInt(maneuver?.color ?? 0xFF77777),
                      size: 12),
                  Text(maneuver?.name ?? '-'),
                ]),
                Text(cue.target, textAlign: TextAlign.center),
                Text(cue.size, textAlign: TextAlign.right),
                Text('${validateIntensity(intensity: cue.intensity)} %'),
                Text(cue.getFrames(), textAlign: TextAlign.center),
                Text('${validateTime(time: cue.time)} ct',
                    textAlign: TextAlign.right),
              ])
            ]),
          ))
        ]),
      );
    }
  }
}

Future<PageTheme> myPageTheme(PdfPageFormat format) async {
  return PageTheme(
    pageFormat: format,
    theme: ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
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
