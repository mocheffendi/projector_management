import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projector_management/utility/shareimage.dart';
import 'package:projector_management/utility/sharepdf.dart';

void showImageDialog(BuildContext context, Uint8List pngBytes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.memory(pngBytes),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.screen_share_rounded),
              ),
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

void showPdfDialog(
    BuildContext context, Uint8List pdfBytes, Uint8List pngBytes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.memory(pngBytes),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.screen_share_rounded),
              ),
              TextButton(
                child: const Text('Share'),
                onPressed: () {
                  if (kIsWeb) {
                    sharepdfweb(pdfBytes);
                  } else {
                    sharepdf(pdfBytes);
                  }
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
