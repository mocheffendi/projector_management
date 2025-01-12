import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareImageFromMemory(String assetPath) async {
  try {
    // Load image bytes from the asset
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();

    // Share the image bytes directly
    await Share.shareXFiles([
      XFile.fromData(bytes,
          name: assetPath.split('/').last, mimeType: 'image/png'),
    ], text: 'Check out this image!');
  } catch (e) {
    debugPrint('Error sharing image: $e');
  }
}
