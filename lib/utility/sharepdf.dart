import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

Future sharepdf(Uint8List pdf) async {
  final tempFile = XFile.fromData(
    pdf,
    mimeType: 'application/pdf',
    name: 'projector.pdf',
  );

  await Share.shareXFiles([tempFile]);
}
