// import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projector_management/rbin/shareimage.dart';
import 'package:projector_management/rbin/sharepdf.dart';

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

// void showPdfDialog(
//     BuildContext context, Uint8List pdfBytes, Uint8List pngBytes) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         // content: Image.memory(pngBytes),
//         content: const SizedBox(
//             // width: 250,
//             height: 200,
//             child: Center(child: Text('Pdf and Image already generated'))),
//         actions: <Widget>[
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       sharepdf(pdfBytes);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       side:
//                           const BorderSide(color: Colors.blueAccent, width: 2),
//                       // minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Icon(Icons.picture_as_pdf_rounded, size: 24),
//                         Text("Share Pdf"),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       shareimage(pngBytes);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       side:
//                           const BorderSide(color: Colors.blueAccent, width: 2),
//                       // minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Icon(Icons.image_rounded, size: 24),
//                         Text("Share Img"),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton.icon(
//                 icon: const Icon(
//                   Icons.home,
//                   // color: Colors.amber,
//                   size: 30.0,
//                 ),
//                 label: const Text('Close'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   side: const BorderSide(color: Colors.blueAccent, width: 2),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }

void showPdfBottomSheet(
    BuildContext context, Uint8List pdfBytes, Uint8List pngBytes) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows dynamic height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.0), // Smooth rounded corners at the top
      ),
    ),
    backgroundColor: Colors.white, // Clean white background
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adapts to content height
          children: [
            // Title Section
            Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const Text(
              'Success!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your PDF and image have been generated successfully. What would you like to do next?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Share PDF Button
                _buildActionButton(
                  context: context,
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'Share PDF',
                  color: Colors.redAccent,
                  onPressed: () => sharepdf(pdfBytes),
                ),
                // Share Image Button
                _buildActionButton(
                  context: context,
                  icon: Icons.image_rounded,
                  label: 'Share Image',
                  color: Colors.blueAccent,
                  onPressed: () => shareimage(pngBytes),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Close Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildActionButton({
  required BuildContext context,
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color.withOpacity(0.1),
      foregroundColor: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    ),
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
