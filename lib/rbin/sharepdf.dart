import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:share_plus/share_plus.dart';

Future sharepdf(Uint8List pdfBytes) async {
  final tempFile = XFile.fromData(
    pdfBytes,
    mimeType: 'application/pdf',
    name: 'projector.pdf',
  );

  await Share.shareXFiles([tempFile]);
}

Future sharepdfweb(Uint8List pdfBytes) async {
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  // ignore: unused_local_variable
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'projector.pdf')
    ..click();
  html.Url.revokeObjectUrl(url);
}
