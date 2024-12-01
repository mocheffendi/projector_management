import 'dart:typed_data';

// import 'package:pdf/pdf.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

Future<Uint8List> convertPdfToPng(Uint8List pdfData) async {
  final pdfDocument = await PdfDocument.openData(pdfData);
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

Future shareimage(Uint8List image) async {
  final tempFile = XFile.fromData(
    image,
    mimeType: 'image/png',
    name: 'screenshot.png',
  );

  await Share.shareXFiles([tempFile]);
}
