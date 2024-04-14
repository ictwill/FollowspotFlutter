// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/extensions/string_extensions.dart';
// import 'package:flutter/widgets.dart' as mt;
import 'package:flutter_to_pdf/args/color.dart';
import 'package:followspot_application_1/src/data/gel_colors.dart';
import 'package:followspot_application_1/src/models/spot.dart';
import 'package:followspot_application_1/src/screens/preferences/icon_names.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../data/number_helpers.dart';
import '../../models/cue.dart';
import '../../models/maneuver.dart';
import '../../models/show.dart';

Future<Uint8List> makePdf(
    PdfPageFormat pageFormat, Show show, int indexSpot) async {
  PageTheme pageTheme = await myPageTheme(pageFormat);

  final numbers = show.cueNumbers();
  final pdf = Document(
    title: show.info.title,
    author: show.info.ld,
  );
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
                      child: Column(
                          children: show.spotList[i].findCues(e).map((cue) {
                    Maneuver? m = show.getManeuver(cue.maneuver);
                    if (m != null && m.header) {
                      return PrintHeaderCard(cue, m);
                    } else {
                      return PrintCompactCard(cue, m);
                    }
                  }).toList()))
              else
                Expanded(
                    child: Column(
                        children: show.spotList[indexSpot]
                            .findCues(e)
                            .map((cue) => PrintWideCard(
                                cue, show.getManeuver(cue.maneuver)))
                            .toList()))
            ],
          );
        }).toList();
      },
    ),
  );
  return await pdf.save();
}

Widget _showHeader({required Show show, required int indexSpot}) {
  return Column(
    children: [
      Table(
        columnWidths: {
          0: const FlexColumnWidth(1),
          1: const FlexColumnWidth(2),
          2: const FlexColumnWidth(1),
        },
        children: [
          TableRow(children: [
            Text(show.info.ld, softWrap: false),
            Text(show.info.title, textAlign: TextAlign.center),
            Text(
                '${show.info.date.year}/${show.info.date.month}/${show.info.date.day}',
                textAlign: TextAlign.right),
          ]),
          TableRow(
            children: [
              Text(show.info.ald, softWrap: false),
              Text(show.info.location, textAlign: TextAlign.center),
              Text(''),
            ],
          ),
        ],
      ),
      Divider(thickness: .1),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        if (indexSpot == -1)
          for (int i = 0; i < show.spotList.length; i++) spotHeader(show, i)
        else
          spotHeader(show, indexSpot)
      ]),
      Divider(thickness: .1),
      SizedBox(height: 12),
    ],
  );
}

Column spotHeader(Show show, int i) {
  return Column(children: [
    Text('Spot ${show.spotList[i].number}', textAlign: TextAlign.center),
    Row(
      children: spotColor(show.spotList[i]),
    ),
  ]);
}

List<Widget> spotColor(Spot spot) {
  List<Row> rowWidgets = [];
  for (int index = 0; index < spot.frames.length; index++) {
    rowWidgets.add(Row(children: [
      Text('${index + 1}: ', textScaleFactor: 0.7),
      Text(spot.frames[index], textScaleFactor: 0.7),
      Icon(
        const IconData(0xef4a),
        size: 10,
        color: getGelHex(spot.frames[index]).toPdfColor(),
      ),
      SizedBox(width: 4)
    ]));
  }

  return rowWidgets;
}

BoxDecoration boxDecoration = BoxDecoration(
    border: Border.all(width: .01), borderRadius: BorderRadius.circular(2));

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
      PdfColor color = getPDFColor(maneuver?.color);
      PdfColor textColor =
          getPDFColor(maneuver!.getContrastingTextColor().value);
      return Container(
        foregroundDecoration: boxDecoration,
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: color,
            ),
            height: cue.height(),
            width: 32,
            alignment: Alignment.center,
            child: Text(deleteTrailing(cue.number),
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor)),
          ),
          if (maneuver?.iconCodePoint != null)
            Icon(IconData(iconNames[maneuver!.iconCodePoint]!),
                color: getPDFColor(maneuver!.color))
          else
            Spacer(),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Table(columnWidths: <int, TableColumnWidth>{
                  0: const FlexColumnWidth(1.0),
                  1: const FlexColumnWidth(2.0),
                  2: const FlexColumnWidth(1.0),
                }, children: [
                  TableRow(children: [
                    paddedText(maneuver?.name ?? '-', TextAlign.start),
                    paddedText(cue.target, TextAlign.center),
                    paddedText(cue.size, TextAlign.end),
                  ]),
                  TableRow(
                      decoration: const BoxDecoration(color: PdfColors.grey100),
                      children: [
                        paddedText(validateIntensity(intensity: cue.intensity),
                            TextAlign.start),
                        paddedText(cue.getFrames(), TextAlign.center),
                        paddedText(validateTime(time: cue.time), TextAlign.end),
                      ]),
                ]),
                if (cue.notes.isNotBlank) paddedText(cue.notes, TextAlign.start)
              ]))
        ]),
      );
    }
  }

  Widget paddedText(String text, TextAlign textAlign) {
    return Container(
        height: 16,
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(vertical: 1.25, horizontal: 4.0),
        child: Text(text, textAlign: textAlign));
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
    } else if (maneuver!.header) {
      return PrintHeaderCard(cue, maneuver);
    } else {
      return Container(
        foregroundDecoration: boxDecoration,
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: getPDFColor(maneuver?.color),
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
            child: Table(columnWidths: <int, TableColumnWidth>{
              0: const FlexColumnWidth(0.5), //Icon
              1: const FlexColumnWidth(2.0), //Action
              2: const FlexColumnWidth(1.0), //Intensity
              3: const FlexColumnWidth(2.0), //Target
              4: const FlexColumnWidth(1.0), //Size
              5: const FlexColumnWidth(1.0), //Frames
              6: const FlexColumnWidth(1.0), //Timing
              7: const FlexColumnWidth(4.0), //Notes
            }, children: [
              TableRow(children: [
                if (maneuver?.iconCodePoint != null)
                  Icon(
                    IconData(iconNames[maneuver!.iconCodePoint]!),
                    color: getPDFColor(maneuver!.color),
                    size: 16,
                  )
                else
                  Spacer(),
                Text(maneuver?.name ?? '-'),
                Text(validateIntensity(intensity: cue.intensity)),
                Text(cue.target),
                Text(cue.size),
                Text(cue.getFrames()),
                Text(validateTime(time: cue.time)),
                Text(cue.notes)
              ])
            ]),
          ))
        ]),
      );
    }
  }
}

///Card Printable Widget for a cue in a column
class PrintHeaderCard extends StatelessWidget {
  final Cue cue;
  final Maneuver? maneuver;

  PrintHeaderCard(this.cue, this.maneuver);

  @override
  Widget build(Context context) {
    if (cue.id == 'blank') {
      return SizedBox(height: 24);
    } else {
      PdfColor color = getPDFColor(maneuver?.color);
      PdfColor textColor =
          getPDFColor(maneuver!.getContrastingTextColor().value);

      return Container(
        color: color,
        foregroundDecoration: boxDecoration,
        child: Row(children: [
          Container(
            height: 24,
            width: 32,
            alignment: Alignment.center,
            child: Text(deleteTrailing(cue.number),
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor)),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Table(columnWidths: <int, TableColumnWidth>{
              0: const FlexColumnWidth(1.0),
              1: const FlexColumnWidth(4.0),
            }, children: [
              TableRow(children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  // Icon(const IconData(0xe530),
                  //     color: PdfColor.fromInt(maneuver?.color ?? 0xFF77777),
                  //     size: 12),
                  Text(maneuver?.name ?? '-',
                      style: TextStyle(color: textColor)),
                ]),
                // Text(cue.target),
                // Text(cue.size),
                // Text(validateIntensity(intensity: cue.intensity)),
                // Text(cue.getFrames()),
                // Text(validateTime(time: cue.time)),
                Text(cue.notes, style: TextStyle(color: textColor))
              ])
            ]),
          ))
        ]),
      );
    }
  }
}

PdfColor getPDFColor(int? color) {
  PdfColor color0 = PdfColor.fromInt(color ?? 0xFF777777);
  if (color0.isDark) {
    return color0.shade(.4);
  } else {
    return color0;
  }
}

Future<PageTheme> myPageTheme(PdfPageFormat format) async {
  // final materialIcons =
  //     await rootBundle.load("assets/fonts/MaterialIcons-Regular.ttf");
  // final materialFont = Font.ttf(materialIcons);
  return PageTheme(
    pageFormat: format,
    theme: ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ).copyWith(
        defaultTextStyle: TextStyle.defaultStyle().copyWith(fontSize: 10.0)),
  );
}
