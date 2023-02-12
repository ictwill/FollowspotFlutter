import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show.dart';
import 'package:followspot_application_1/src/screens/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({super.key, required this.show});

  static const routeName = '/print_preview';

  final Show show;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PdfPageFormat pageFormat = PdfPageFormat.letter;
  int selectedSpotindex = -1;

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
        initialPageFormat: pageFormat,
        onPageFormatChanged: (value) {
          setState(() {
            pageFormat = value;
          });
        },
        build: (format) => makePdf(format, widget.show, selectedSpotindex),
      ),
    );
  }
}
