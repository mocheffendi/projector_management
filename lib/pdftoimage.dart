import 'dart:typed_data';

// import 'package:pdf/pdf.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

Future<Uint8List> convertPdfToPng(Uint8List pdfData) async {
  final pdfDocument = await PdfDocument.openData(pdfData);
  final page = await pdfDocument.getPage(1);
  final pageImage = await page.render(
    width: page.width,
    height: page.height,
    format: PdfPageImageFormat.png,
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
