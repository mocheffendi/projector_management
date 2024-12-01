// import 'package:pdf/pdf.dart';
// import 'package:pdfrx/pdfrx.dart';
// import 'package:printing/printing.dart';

import 'package:flutter/foundation.dart';
import 'package:pdfx/pdfx.dart';

// import 'package:pdf_render/pdf_render.dart';

Future<Uint8List> convertPdfToPng(Uint8List pdfBytes) async {
  final pdfDocument = await PdfDocument.openData(pdfBytes);
  final page = await pdfDocument.getPage(1);

  // Set the desired resolution by adjusting width and height final width = 2480; // Example for 300 DPI for an 8.5"x11" page final height = 3508
  double width = 1350; // Example for 300 DPI for an 8.5"x11" page
  double height = 3600;

  final pageImage = await page.render(
    width: width,
    height: height,
    format: PdfPageImageFormat.png,
    quality: 100,
  );

  return pageImage!.bytes;
}
