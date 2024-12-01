import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';
import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
// import 'package:pdfrx/pdfrx.dart';
// import 'package:internet_file/internet_file.dart';
// import 'package:pdfx/pdfx.dart' as pdfx;
// import 'package:projector_management/googledrivepdf.dart';
import 'package:projector_management/pdftoimage.dart';
// import 'package:projector_management/googledrivepdfviewer.dart';
// import 'package:pdf_viewer_pinch/pdf_viewer_pinch.dart';
// import 'package:universal_platform/universal_platform.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';

// import 'package:image/image.dart' as img;

// import 'package:scroll_screenshot/scroll_screenshot.dart';

// import 'package:widget_screenshot/widget_screenshot.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;
// import 'package:printing/printing.dart' as print;
// import 'package:pdfrx/pdfrx.dart' as pdfrx;
// import 'pdfpreview.dart';
// import 'image_previews.dart';

// Your Projector Management Page

class ProjectorPage extends StatefulWidget {
  const ProjectorPage({super.key});

  @override
  State<ProjectorPage> createState() => _ProjectorPageState();
}

class _ProjectorPageState extends State<ProjectorPage> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _generatePdfandShareSupportWeb() async {
    final pdf = pw.Document();

    // Fetch data from Firestore
    final querySnapshot =
        await FirebaseFirestore.instance.collection('projectors').get();
    final projectors = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config')
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          roomOptions = List<String>.from(data['roomOptions']);
          notOccupiedStatuses = List<String>.from(data['notOccupiedStatuses']);
        });
      }
    } catch (e) {
      log('Error fetching settings: $e');
    }

    // Example statuses
    final occupiedProjectors = projectors
        .where(
            (projector) => !notOccupiedStatuses.contains(projector['status']))
        .toList();
    final notOccupiedProjectors = projectors
        .where((projector) => notOccupiedStatuses.contains(projector['status']))
        .toList();

    // Add data to PDF
    if (occupiedProjectors.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(450, 1250, marginAll: 8),
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Occupied Projectors',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
              pw.SizedBox(height: 5),
              ...occupiedProjectors.map((projector) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 5),
                  child: _buildProjectorCardpw(projector),
                );
              }).toList(),
              pw.SizedBox(height: 5),
              pw.Text(
                'Not Occupied Projectors',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                ),
              ),
              pw.SizedBox(height: 5),
              ...notOccupiedProjectors.map((projector) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 5),
                  child: _buildProjectorCardpw(projector),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }

    // if (notOccupiedProjectors.isNotEmpty) {
    //   pdf.addPage(
    //     pw.Page(
    //       pageFormat: const PdfPageFormat(596, 842, marginAll: 5),
    //       build: (pw.Context context) => pw.Column(
    //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           pw.Text(
    //             'Not Occupied Projectors',
    //             style: pw.TextStyle(
    //               fontSize: 18,
    //               fontWeight: pw.FontWeight.bold,
    //               color: PdfColors.green,
    //             ),
    //           ),
    //           pw.SizedBox(height: 10),
    //           ...notOccupiedProjectors.map((projector) {
    //             return pw.Container(
    //               margin: const pw.EdgeInsets.only(bottom: 10),
    //               child: _buildProjectorCardpw(projector),
    //             );
    //           }).toList(),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    final bytes = await pdf.save();

    final image = await convertPdfToPng(bytes);

    // Show Dialog with Image
    showImageDialog(context, image);
    // ShowCapturedWidget(context, image);
    // await Printing.sharePdf(bytes: bytes, filename: 'projector_report.pdf');

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PdfPreviewScreen(pdfBytes: bytes),
    //   ),
    // );

    // Printing.sharePdf(
    //   bytes: bytes,
    //   filename: 'Projector_Report.pdf',
    // );

    // _sharePdf(bytes, context);

    // Open the PDF in a dialog using pdfx
    // _showPdfViewerDialog(context, bytes);

    // Create a blob and use HTML AnchorElement to download the PDF
    // final blob = html.Blob([bytes], 'application/pdf');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // // Check if the browser supports the Web Share API
    // html.window.navigator.share({
    //   'url': url,
    //   'title': 'Shared PDF',
    //   'text': 'Please find the attached PDF document.',
    // }).catchError((error) {
    //   print("Share failed: $error");
    // });

    // final anchor = html.AnchorElement(href: url)
    //   ..target = '_blank'
    //   ..download = "projectors_report.pdf"
    //   ..click();

    // html.Url.revokeObjectUrl(url);

    // if (mounted) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => GoogleDrivePdf(pdfBytes: bytes)));
    // }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF Download successfully!")),
      );
    }
    // Convert PDF to PNG
    // final pngImages = await _convertPdfToPng(bytes);
    // sharePdfForWeb(bytes, "example.pdf");

    // ShowCapturedWidget2(context, image);
    // The argument type 'List<Uint8List>' can't be assigned to the parameter type 'Uint8List'.
    // Wait for the user to trigger share
    // await _sharePdf(Uint8List.fromList(bytes));
  }

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

  List<String> roomOptions = [];
  List<String> notOccupiedStatuses = [];

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config')
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          roomOptions = List<String>.from(data['roomOptions']);
          notOccupiedStatuses = List<String>.from(data['notOccupiedStatuses']);
        });
      }
    } catch (e) {
      log('Error fetching settings: $e');
    }
  }

  void ShowCapturedWidget(BuildContext context, Uint8List capturedImage) {
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

  // Future<dynamic> ShowCapturedWidget(
  //     BuildContext context, Uint8List capturedImage) {
  //   return showDialog(
  //     useSafeArea: false,
  //     context: context,
  //     builder: (context) => Scaffold(
  //       appBar: AppBar(
  //         title: const Text("Captured widget screenshot"),
  //       ),
  //       body: Center(child: Image.memory(capturedImage)),
  //     ),
  //   );
  // }

  // final List<String> roomOptions = [
  //   'Argon I',
  //   'Argon II',
  //   'Atmosphere',
  //   'Ballroom A',
  //   'Ballroom B',
  //   'Crypton',
  //   'East Destination',
  //   'FO Office',
  //   'Food Exchange',
  //   'Grand Argon',
  //   'Grand Ballroom',
  //   'Grand Destination',
  //   'Helium',
  //   'Hydrogen',
  //   'Main Destination',
  //   'Neon',
  //   'Nitrogen',
  //   'not use',
  //   'Oxygen',
  //   'Pantry / Panel Heritage',
  //   'Pantry / Panel Lantai3',
  //   'Pantry / Panel Lantai5',
  //   'Pantry / Panel Una²',
  //   'Plataran',
  //   'VIP Ballroom',
  //   'Warehouse LT2',
  //   'West Destination',
  //   'Una Una Exec Lounge',
  //   'Una Una GD',
  //   'The Heritage',
  //   'Xenon'
  // ];

  // // Define a list of statuses that represent "not occupied."
  // final List<String> notOccupiedStatuses = [
  //   'not use',
  //   'FO Office',
  //   'Warehouse LT2',
  //   'Pantry / Panel Una²',
  //   'Pantry / Panel Lantai5',
  //   'Pantry / Panel Lantai3',
  //   'Pantry / Panel Heritage',
  // ];

  Future<List<Map<String, dynamic>>> fetchProjectors() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('projectors').get();
      List<Map<String, dynamic>> projectors = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'model': data['model'],
          'sn': data['sn'],
          'status': data['status'],
          'image': data['image'],
          'lastUpdated':
              data['lastUpdated']?.toDate(), // Handle the date conversion
          'occupied': data['status'] != 'not use',
        };
      }).toList();
      return projectors;
    } catch (e) {
      log("Error fetching projectors: $e");
      return [];
    }
  }

  Future<void> updateStatus(String projectorId, String newStatus) async {
    final now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('projectors')
        .doc(projectorId)
        .update({
      'status': newStatus,
      'lastUpdated': now, // Update timestamp
    });
  }

  Future<void> updateProjector(String id, String model, String sn,
      String base64Image, String status) async {
    try {
      await FirebaseFirestore.instance.collection('projectors').doc(id).update({
        'model': model,
        'sn': sn,
        'status': status,
        'image': base64Image, // Save base64 image string
        'lastUpdated': FieldValue.serverTimestamp(), // Update timestamp on edit
      });
      setState(() {});
    } catch (e) {
      log("Error updating projector: $e");
    }
  }

  Future<void> deleteProjector(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('projectors')
          .doc(id)
          .delete();
      setState(() {});
    } catch (e) {
      log("Error deleting projector: $e");
    }
  }

  Future<void> addProjector(String model, String sn, String base64Image) async {
    try {
      await FirebaseFirestore.instance.collection('projectors').add({
        'model': model,
        'sn': sn,
        'status': 'not use',
        'image': base64Image, // Save base64 image string
        'lastUpdated':
            FieldValue.serverTimestamp(), // Add timestamp when adding
      });
      setState(() {});
    } catch (e) {
      log("Error adding projector: $e");
    }
  }

  Future<void> _showAddProjectorDialog() async {
    final TextEditingController modelController = TextEditingController();
    final TextEditingController snController = TextEditingController();
    String? base64Image;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Projector'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              TextField(
                controller: snController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    final bytes = result.files.single.bytes;
                    base64Image = base64Encode(bytes!);
                  }
                },
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (modelController.text.isNotEmpty &&
                    snController.text.isNotEmpty &&
                    base64Image != null) {
                  addProjector(
                      modelController.text, snController.text, base64Image!);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(String projectorId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Projector'),
          content:
              const Text('Are you sure you want to delete this projector?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProjector(projectorId); // Perform delete action
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.red, // Red button for delete
                  ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditProjectorDialog(Map<String, dynamic> projector) async {
    final TextEditingController modelController =
        TextEditingController(text: projector['model']);
    final TextEditingController snController =
        TextEditingController(text: projector['sn']);
    String? base64Image = projector['image'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Projector'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              TextField(
                controller: snController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    final bytes = result.files.single.bytes;
                    base64Image = base64Encode(bytes!);
                  }
                },
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (modelController.text.isNotEmpty &&
                    snController.text.isNotEmpty &&
                    base64Image != null) {
                  updateProjector(projector['id'], modelController.text,
                      snController.text, base64Image!, projector['status']);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build projector card
  Widget _buildProjectorCard(Map<String, dynamic> projector) {
    final lastUpdated = projector['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm:ss').format(lastUpdated)
        : 'Unknown';
    Color cardColor = [
      'not use',
      'FO Office',
      'Store LT2',
      'Pantry / Panel Una²',
      'Pantry / Panel Lantai5',
      'Pantry / Panel Lantai3',
      'Pantry / Panel Heritage',
      'Office Eng'
    ].contains(projector['status'])
        ? Colors.green.shade100
        : Colors.grey.shade300;

    return Card.filled(
      elevation: 8.0,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.memory(
              base64Decode(projector['image'] ?? ''),
              width: 150,
              height: 100,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${projector['model']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('SN: ${projector['sn']}'),
                  Text(
                    notOccupiedStatuses.contains(projector['status'])
                        ? 'Not Occupied @${projector['status']}'
                        : 'Occupied @${projector['status']}',
                    style: TextStyle(
                      color: notOccupiedStatuses.contains(projector['status'])
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Text(
                    'Last Updated: $formattedDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                    value: projector['status'],
                    onChanged: (newValue) {
                      if (newValue != null) {
                        updateStatus(projector['id'], newValue);
                      }
                    },
                    items: roomOptions.map((room) {
                      return DropdownMenuItem<String>(
                        value: room,
                        child: Text(room),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Edit') {
                  _showEditProjectorDialog(projector);
                } else if (value == 'Delete') {
                  _showDeleteConfirmationDialog(projector['id']);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_note),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    )),
                const PopupMenuItem(
                    value: 'Delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildProjectorCardpw(Map<String, dynamic> projector) {
    final lastUpdated = projector['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm:ss').format(lastUpdated)
        : 'Unknown';

    // Determine card color based on status
    final cardColor = [
      'not use',
      'FO Office',
      'Store LT2',
      'Pantry / Panel Una²',
      'Pantry / Panel Lantai5',
      'Pantry / Panel Lantai3',
      'Pantry / Panel Heritage',
      'Office Eng'
    ].contains(projector['status'])
        ? PdfColors.green100
        : PdfColors.grey300;

    return pw.Container(
      decoration: pw.BoxDecoration(
          color: cardColor, borderRadius: pw.BorderRadius.circular(15)),
      margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          projector['image'] != null
              ? pw.Image(
                  pw.MemoryImage(base64Decode(projector['image'] ?? '')),
                  width: 150,
                  height: 100,
                  fit: pw.BoxFit.fitWidth,
                )
              : pw.Container(
                  width: 150,
                  height: 100,
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  child: pw.Center(child: pw.Text("No Image")),
                ),
          pw.SizedBox(width: 5),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${projector['model']}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('SN: ${projector['sn']}'),
                pw.Text(
                  notOccupiedStatuses.contains(projector['status'])
                      ? 'Not Occupied @${projector['status']}'
                      : 'Occupied @${projector['status']}',
                  style: pw.TextStyle(
                    color: notOccupiedStatuses.contains(projector['status'])
                        ? PdfColors.green
                        : PdfColors.red,
                  ),
                ),
                pw.Text(
                  'Last Updated: $formattedDate',
                  style:
                      const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
                // Dropdowns and popup menus are not supported in PDF widgets.
                // Replace with static information or remove them.
                pw.Text('Status: ${projector['status']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('projectors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No projectors found.'));
          } else {
            // Extract and categorize projectors
            final projectors = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                ...data,
              };
            }).toList();

            // Categorize projectors
            final occupiedProjectors = projectors
                .where((projector) =>
                    !notOccupiedStatuses.contains(projector['status']))
                .toList();

            final notOccupiedProjectors = projectors
                .where((projector) =>
                    notOccupiedStatuses.contains(projector['status']))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (occupiedProjectors.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Occupied',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ...occupiedProjectors.map((projector) {
                      return _buildProjectorCard(projector);
                    }).toList(),
                  ],
                  if (notOccupiedProjectors.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Not Occupied',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    ...notOccupiedProjectors.map((projector) {
                      return _buildProjectorCard(projector);
                    }).toList(),
                  ],
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          log('button Pressed');
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const PdfPreviewPage()));
          _generatePdfandShareSupportWeb();
          // String? base64String =
          //     await ScrollScreenshot.captureAndSaveScreenshot(globalKey);
          // Uint8List _bytesImage;

          // _bytesImage = Base64Decoder().convert(base64String!);

          // WidgetShotRenderRepaintBoundary repaintBoundary =
          //     _shotKey.currentContext!.findRenderObject()
          //         as WidgetShotRenderRepaintBoundary;
          // var resultImage = await repaintBoundary.screenshot(
          //     scrollController: _scrollController,
          //     backgroundColor: Colors.white,
          //     format: ShotFormat.png,
          //     pixelRatio: 1);
          // try {
          //   // Map<dynamic, dynamic> result =
          //   //     await ImageGallerySaver.saveImage(resultImage!);
          //   //
          //   // debugPrint("result = ${result}");

          //   /// 存储的文件的路径
          //   String path = (await getTemporaryDirectory()).path;
          //   path += '/${DateTime.now().toString()}.png';
          //   File file = File(path);
          //   if (!file.existsSync()) {
          //     file.createSync();
          //   }
          //   await file.writeAsBytes(resultImage!);
          //   debugPrint("result = ${file.path}");
          // } catch (error) {
          //   /// flutter保存图片到App内存文件夹出错
          //   debugPrint("error = $error");
          // }
          // ShowCapturedWidget(context, resultImage!);

          // log(base64String!);
          // var container = Container(
          //     padding: const EdgeInsets.all(10.0),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.blueAccent, width: 5.0),
          //       color: Colors.redAccent,
          //     ),
          //     child: Container(
          //       child: StreamBuilder<QuerySnapshot>(
          //         stream: FirebaseFirestore.instance
          //             .collection('projectors')
          //             .snapshots(),
          //         builder: (context, snapshot) {
          //           if (snapshot.connectionState == ConnectionState.waiting) {
          //             return const Center(child: CircularProgressIndicator());
          //           } else if (snapshot.hasError) {
          //             return Center(child: Text('Error: ${snapshot.error}'));
          //           } else if (!snapshot.hasData ||
          //               snapshot.data!.docs.isEmpty) {
          //             return const Center(child: Text('No projectors found.'));
          //           } else {
          //             // Extract and categorize projectors
          //             final projectors = snapshot.data!.docs.map((doc) {
          //               final data = doc.data() as Map<String, dynamic>;
          //               return {
          //                 'id': doc.id,
          //                 ...data,
          //               };
          //             }).toList();

          //             // Categorize projectors
          //             final occupiedProjectors = projectors
          //                 .where((projector) => !notOccupiedStatuses
          //                     .contains(projector['status']))
          //                 .toList();

          //             final notOccupiedProjectors = projectors
          //                 .where((projector) =>
          //                     notOccupiedStatuses.contains(projector['status']))
          //                 .toList();

          //             return Container(
          //               height: double.infinity,
          //               child: Screenshot(
          //                 controller: screenshotController,
          //                 child: SingleChildScrollView(
          //                   child: RepaintBoundary(
          //                     child: Column(children: [
          //                       Text('data'),
          //                       // ListView(
          //                       //   physics: NeverScrollableScrollPhysics(),
          //                       //   shrinkWrap: true,
          //                       //   children: [
          //                       //     ListTile(
          //                       //       title: const Text("Single Example"),
          //                       //       onTap: () {
          //                       //         Navigator.of(context)
          //                       //             .push(MaterialPageRoute(
          //                       //           builder: (context) {
          //                       //             return Container();
          //                       //             // return const ExampleSinglePage();
          //                       //           },
          //                       //         ));
          //                       //       },
          //                       //     ),
          //                       //     ListTile(
          //                       //       title: const Text("List Example"),
          //                       //       onTap: () {
          //                       //         Navigator.of(context)
          //                       //             .push(MaterialPageRoute(
          //                       //           builder: (context) {
          //                       //             return Container();
          //                       //             // return const ExampleListPage();
          //                       //           },
          //                       //         ));
          //                       //       },
          //                       //     ),
          //                       //     ListTile(
          //                       //       title: const Text("List Extra Example"),
          //                       //       onTap: () {
          //                       //         Navigator.of(context)
          //                       //             .push(MaterialPageRoute(
          //                       //           builder: (context) {
          //                       //             return Container();
          //                       //             // return const ExampleListExtraPage();
          //                       //           },
          //                       //         ));
          //                       //       },
          //                       //     ),
          //                       //     ListTile(
          //                       //       title: const Text("ScrollView Example"),
          //                       //       onTap: () {
          //                       //         Navigator.of(context)
          //                       //             .push(MaterialPageRoute(
          //                       //           builder: (context) {
          //                       //             return Container();
          //                       //             // return const ExampleScrollViewExtraPage();
          //                       //           },
          //                       //         ));
          //                       //       },
          //                       //     ),
          //                       //   ],
          //                       // ),
          //                     ]),
          //                   ),
          //                 ),
          //               ),
          //             );

          //             // return ListView(
          //             //   controller: _scrollController,
          //             //   children: [
          //             //     if (occupiedProjectors.isNotEmpty) ...[
          //             //       const Padding(
          //             //         padding: EdgeInsets.all(8.0),
          //             //         child: Text(
          //             //           'Occupied',
          //             //           style: TextStyle(
          //             //             fontSize: 18,
          //             //             fontWeight: FontWeight.bold,
          //             //             color: Colors.red,
          //             //           ),
          //             //         ),
          //             //       ),
          //             //       ...occupiedProjectors.map((projector) {
          //             //         return _buildProjectorCard(projector);
          //             //       }).toList(),
          //             //     ],
          //             //     if (notOccupiedProjectors.isNotEmpty) ...[
          //             //       const Padding(
          //             //         padding: EdgeInsets.all(8.0),
          //             //         child: Text(
          //             //           'Not Occupied',
          //             //           style: TextStyle(
          //             //             fontSize: 18,
          //             //             fontWeight: FontWeight.bold,
          //             //             color: Colors.green,
          //             //           ),
          //             //         ),
          //             //       ),
          //             //       ...notOccupiedProjectors.map((projector) {
          //             //         return _buildProjectorCard(projector);
          //             //       }).toList(),
          //             //     ],
          //             //   ],
          //             // );
          //           }
          //         },
          //       ),
          //     ));
          // screenshotController
          //     .captureFromWidget(
          //         InheritedTheme.captureAll(
          //             context, Material(child: container)),
          //         delay: Duration(seconds: 1),
          //         targetSize: const Size(800, 2000))
          //     .then((capturedImage) {
          //   ShowCapturedWidget(context, capturedImage);
          // });
          // screenshotController
          //     .capture(delay: Duration(milliseconds: 10))
          //     .then((capturedImage) async {
          //   ShowCapturedWidget(context, capturedImage!);
          // }).catchError((onError) {
          //   print(onError);
          // });
        },
        // onPressed: _showAddProjectorDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
