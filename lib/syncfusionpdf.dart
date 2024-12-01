import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;

  const PdfPreviewScreen({super.key, required this.pdfBytes});

  void _sharePdf() async {
    // Save the PDF to a file
    // final filePath = await _savePdfToFile(pdfBytes);

    final file = XFile.fromData(
      pdfBytes,
      name: 'projectors_report.pdf',
      mimeType: 'application/pdf',
    );

    // Share the PDF file
    await Share.shareXFiles([file], text: 'Check out this PDF!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: Column(
        children: [
          Expanded(child: SfPdfViewer.memory(pdfBytes)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _sharePdf(),
              child: Text('Share PDF'),
            ),
          ),
        ],
      ),
    );
  }
}

class PdfGeneratorScreen extends StatelessWidget {
  const PdfGeneratorScreen({super.key});

  void _generateAndPreviewPdf(BuildContext context) async {
    // Step 1: Create a PDF document.
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    // Add content to the PDF page.
    page.graphics.drawString(
      'Hello, Syncfusion PDF!',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
    );

    // Step 2: Save the PDF document to a byte array.
    final List<int> pdfList = await document.save();

    // Convert List<int> to Uint8List
    final Uint8List pdfBytes = Uint8List.fromList(pdfList);

    // Dispose the document to free resources.
    document.dispose();

    // Step 3: Navigate to the preview screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(pdfBytes: pdfBytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate PDF')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _generateAndPreviewPdf(context),
          child: const Text('Generate and Preview PDF'),
        ),
      ),
    );
  }
}
