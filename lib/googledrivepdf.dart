import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;

class GoogleDrivePdf extends StatefulWidget {
  final Uint8List pdfBytes;
  const GoogleDrivePdf({Key? key, required this.pdfBytes}) : super(key: key);

  @override
  State<GoogleDrivePdf> createState() => _GoogleDrivePdfState();
}

class _GoogleDrivePdfState extends State<GoogleDrivePdf> {
  // late Uint8List pdfBytes;

  @override
  void initState() {
    super.initState();
    // _generatePdf();
  }

  // Future<void> _generatePdf() async {
  //   // Generate a sample PDF
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) => pw.Center(
  //         child: pw.Text("Hello, this is a PDF!"),
  //       ),
  //     ),
  //   );

  //   // Save the PDF as bytes
  //   pdfBytes = await pdf.save();

  //   // Refresh the UI
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projectors Report")),
      body: widget.pdfBytes == null
          ? const Center(child: CircularProgressIndicator())
          : PdfPreview(
              build: (format) async => widget.pdfBytes,
              allowSharing: true,
              allowPrinting: false,
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
              pdfFileName: 'projectors_report.pdf',
              pdfPreviewPageDecoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              actionBarTheme:
                  const PdfActionBarTheme(backgroundColor: Colors.deepOrange),
            ),
    );
  }
}
