import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:projector_management/utility/pdftoimage.dart';

void showImageDialog(BuildContext context, Uint8List pngBytes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.memory(pngBytes),
        actions: <Widget>[
          Row(
            children: [
              TextButton(
                child: const Text('Share'),
                onPressed: () {
                  shareimage(pngBytes);
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showCapturedWidget(BuildContext context, Uint8List capturedImage) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Captured Screenshot"),
      content: Image.memory(capturedImage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}
