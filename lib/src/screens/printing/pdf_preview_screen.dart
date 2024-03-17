import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../models/show.dart';
import '../../settings/settings_controller.dart';
import '../../settings/settings_view.dart';
import '../preferences/show_info_edit_view.dart';
import 'printing.dart';

enum PrintMargins { top, left, right, bottom }

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen(
      {super.key, required this.show, required this.controller});

  static const routeName = '/printpreview';
  final SettingsController controller;

  final Show show;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  int selectedSpotindex = -1;
  bool shouldRedraw = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: PopupMenuButton<int>(
          initialValue: selectedSpotindex,
          onSelected: (value) {
            setState(() {
              selectedSpotindex = value;
            });
          },
          itemBuilder: (context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: -1,
              child: ListTile(
                title: Text('Show All Spots'),
              ),
            ),
            for (var spot in widget.show.spotList)
              PopupMenuItem<int>(
                value: spot.number - 1,
                child: ListTile(
                  title: Text('Spot ${spot.number}'),
                ),
              ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                selectedSpotindex == -1
                    ? 'Show All'
                    : 'Spot ${selectedSpotindex + 1}',
                textAlign: TextAlign.center,
              ),
              const Icon(Icons.arrow_drop_down),
            ]),
          ),
        ),
      ),
      body: PdfPreview(
        pdfFileName: getPdfName,
        initialPageFormat: widget.controller.pageFormat,
        onPageFormatChanged: (format) {
          widget.controller.changePageFormat(format);
          setState(() {
            shouldRedraw = true;
          });
        },
        shouldRepaint: shouldRedraw,
        useActions: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _savePDFFile(
                  context,
                  (format) => makePdf(format, widget.show, selectedSpotindex),
                  widget.controller.pageFormat,
                  getPdfName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, ShowInfoEditView.routeName);
            },
          ),
        ],
        build: (format) => makePdf(format, widget.show, selectedSpotindex),
      ),
    );
  }

  String get getPdfName {
    DateTime date = widget.show.info.date;
    DateFormat formatter = DateFormat('yyyy-MM-dd HHmm');
    String formattedDate = formatter.format(date);
    return '${widget.show.info.title} - $formattedDate.pdf';
  }
}

Future<void> _savePDFFile(
  BuildContext context,
  LayoutCallback build,
  PdfPageFormat pageFormat,
  String filename,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath\\$filename');
  print('Save as file ${file.path} ...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

// Printing.layoutPdf(
//               // [onLayout] will be called multiple times
//               // when the user changes the printer or printer settings
//               onLayout: (PdfPageFormat format) {
//                 // Any valid Pdf document can be returned here as a list of int
//                 return buildPdf(format);
//               },
//             );

//               /// This method takes a page format and generates the Pdf file data
//   Future<Uint8List> buildPdf(PdfPageFormat format) async {
//     // Create the Pdf document
//     final pw.Document doc = pw.Document();

//     // Add one page with centered text "Hello World"
//     doc.addPage(
//       pw.Page(
//         pageFormat: format,
//         build: (pw.Context context) {
//           return pw.ConstrainedBox(
//             constraints: pw.BoxConstraints.expand(),
//             child: pw.FittedBox(
//               child: pw.Text('Hello World'),
//             ),
//           );
//         },
//       ),
//     );

//     // Build and return the final Pdf file data
//     return await doc.save();
//   }