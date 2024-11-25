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
  final ScreenshotController _screenshotController = ScreenshotController();
  final ScrollController _scrollController = ScrollController();

  // Define a list of statuses for projectors
  final List<String> notOccupiedStatuses = [
    'Available',
    'Idle'
  ]; // Example statuses

  Widget buildProjectorCard(Map<String, dynamic> projector) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(projector['model']),
          Text('Serial Number: ${projector['sn'] ?? 'Unknown'}'),
          Text('Status: ${projector['status'] ?? 'Unknown'}'),
          // Text('Last Updated: $formattedDate'),
          SizedBox(height: 16.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // _showEditProjectorDialog(projector);
                },
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  // _showDeleteConfirmationDialog(projector['id']);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void captureFullPageScreenshot() async {
    try {
      // Build the widget to capture
      Widget container = Builder(
        builder: (context) {
          return Container(
            width: 600,
            height: 2000,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('projectors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No projectors found.'));
                } else {
                  final projectors = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'id': doc.id,
                      ...data,
                    };
                  }).toList();

                  final occupiedProjectors = projectors
                      .where((projector) =>
                          !notOccupiedStatuses.contains(projector['status']))
                      .toList();

                  final notOccupiedProjectors = projectors
                      .where((projector) =>
                          notOccupiedStatuses.contains(projector['status']))
                      .toList();

                  return ListView(
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
          );
        },
      );

      // Capture the widget as an image
      final Uint8List? capturedImage =
          await _screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(context, Material(child: container)),
        delay: const Duration(milliseconds: 100),
        context: context,
      );

      if (capturedImage != null) {
        _showCapturedWidget(capturedImage);
      } else {
        print('Failed to capture the screenshot');
      }
    } catch (e) {
      print('Error capturing full-page screenshot: $e');
    }
  }

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

  Widget _buildProjectorCard(Map<String, dynamic> projector) {
    final name = projector['name'] ?? 'Unnamed Projector';
    final status = projector['status'] ?? 'Unknown';
    final isOccupied = status.toLowerCase() == 'occupied';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(name),
        subtitle: Text('Status: $status'),
        trailing: Icon(
          isOccupied ? Icons.cancel : Icons.check_circle,
          color: isOccupied ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projectors")),
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
            final projectors = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                ...data,
              };
            }).toList();

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
      floatingActionButton: FloatingActionButton(
        onPressed: captureFullPageScreenshot,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
