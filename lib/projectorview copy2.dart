import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:typed_data';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:image/image.dart' as img;

// import 'image_previews.dart';

// Your Projector Management Page

class ProjectorPage extends StatefulWidget {
  const ProjectorPage({super.key});

  @override
  State<ProjectorPage> createState() => _ProjectorPageState();
}

class _ProjectorPageState extends State<ProjectorPage> {
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // Define a list of statuses for projectors
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

  FullPageScreenshot(
      ScreenshotController screenshotController, BuildContext context) {
    screenshotController
        .capture(delay: const Duration(milliseconds: 100), pixelRatio: 2.0)
        .then((Uint8List? capturedImage) async {
      if (capturedImage != null) {
        // Display the captured image
        if (mounted) {
          ShowCapturedWidget(context, capturedImage);
        }
        // Share the image
        final tempFile = XFile.fromData(
          capturedImage,
          mimeType: 'image/png',
          name: 'screenshot.png',
        );

        await Share.shareXFiles([tempFile]);
      }
    }).catchError((e) {
      debugPrint('Error capturing screenshot: $e');
    });
  }

  void captureAndShareScreenshot(
      ScreenshotController screenshotController, BuildContext context) {
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? capturedImage) async {
      if (capturedImage != null) {
        // Display the captured image
        ShowCapturedWidget(context, capturedImage);

        // Share the image
        final tempFile = XFile.fromData(
          capturedImage,
          mimeType: 'image/png',
          name: 'screenshot.png',
        );

        await Share.shareXFiles([tempFile]);
      }
    }).catchError((e) {
      debugPrint('Error capturing screenshot: $e');
    });
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
      'Warehouse LT2',
      'Pantry / Panel Una²',
      'Pantry / Panel Lantai5',
      'Pantry / Panel Lantai3',
      'Pantry / Panel Heritage'
    ].contains(projector['status'])
        ? Colors.green.shade100
        : Colors.white;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projectors")),
      body: RepaintBoundary(
        key: _globalKey,
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('projectors').snapshots(),
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

              return ListView(
                controller: _scrollController,
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
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureFullPageScreenshot,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  // Method to capture the screenshot of the entire scaffold
  Future<void> _captureFullPageScreenshot() async {
    try {
      // Capture the entire widget using RepaintBoundary
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(
          pixelRatio: 3.0); // Adjust pixel ratio for resolution
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Process or save the captured image
      print('Captured screenshot, size: ${pngBytes.lengthInBytes} bytes');

      // You can show the image or save it here.
      // For example, use an image display widget or save the file.
      _showCapturedWidget(pngBytes);
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }

  // Show the captured screenshot as a new widget
  void _showCapturedWidget(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.memory(imageBytes),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
