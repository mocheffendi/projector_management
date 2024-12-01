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
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.screen_share_rounded),
              // ),
              // TextButton(
              //   child: const Text('Share Pdf'),
              //   onPressed: () {
              //     if (kIsWeb) {
              //       sharepdfweb(pdfBytes);
              //     } else {
              //       sharepdf(pdfBytes);
              //     }
              //   },
              // ),
              ElevatedButton(
                onPressed: () {
                  sharepdf(pdfBytes);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.image_rounded, size: 24),
                    Text("Share Img"),
                  ],
                ),
              ),
              // IconButtonWithLabel(
              //     icon: Icons.picture_as_pdf_rounded,
              //     label: 'Share Pdf',
              //     onPressed: () {
              //       sharepdf(pdfBytes);
              //     }),
              const SizedBox(
                width: 10,
              ),
              // IconButtonWithLabel(
              //     icon: Icons.image_rounded,
              //     label: 'Share Image',
              //     onPressed: () {
              //       shareimage(pngBytes);
              //     }),
              // TextButton(
              //   child: const Text('Share Pdf'),
              //   onPressed: () {
              //     sharepdf(pdfBytes);
              //   },
              // ),
              // TextButton(
              //   child: const Text('Share Image'),
              //   onPressed: () {
              //     shareimage(pngBytes);
              //   },
              // ),
              const SizedBox(
                width: 8,
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
