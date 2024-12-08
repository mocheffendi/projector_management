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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sharepdf(pdfBytes);
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.transparent, width: 1),
                      // minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.picture_as_pdf_rounded, size: 24),
                        Text("Share Pdf"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      shareimage(pngBytes);
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.transparent, width: 1),
                      // minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.image_rounded, size: 24),
                        Text("Share Img"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.home,
                  // color: Colors.amber,
                  size: 30.0,
                ),
                label: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueAccent, width: 2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
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
