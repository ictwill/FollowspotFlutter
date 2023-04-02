import 'package:flutter/material.dart';
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
        pdfFileName: '${widget.show.filename}.pdf',
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
}
