import 'package:flutter/material.dart';
import 'package:followspot_application_1/src/models/show.dart';
import 'package:followspot_application_1/src/screens/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key, required this.show});

  static const routeName = '/print_preview';

  final Show show;
  final PdfPageFormat pageFormat = PdfPageFormat.a4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Export PDF'),
      ]),
      body: PdfPreview(
        build: (format) => makePdf(pageFormat, show),
      ),
    );
  }
}
