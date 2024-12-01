import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

Future shareimage(Uint8List image) async {
  final tempFile = XFile.fromData(
    image,
    mimeType: 'image/png',
    name: 'screenshot.png',
  );

  await Share.shareXFiles([tempFile]);
}
