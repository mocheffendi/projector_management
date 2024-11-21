import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

// Your AVDevice Management Page

class AVDevicePage extends StatefulWidget {
  const AVDevicePage({super.key});

  @override
  State<AVDevicePage> createState() => _AVDevicePageState();
}

class _AVDevicePageState extends State<AVDevicePage> {
  final List<String> roomOptions = [
    'Argon I',
    'Argon II',
    'Atmosphere',
    'Ballroom A',
    'Ballroom B',
    'Crypton',
    'East Destination',
    'FO Office',
    'Food Exchange',
    'Grand Argon',
    'Grand Ballroom',
    'Grand Destination',
    'Helium',
    'Hydrogen',
    'Main Destination',
    'Neon',
    'Nitrogen',
    'not use',
    'Oxygen',
    'Pantry / Panel Heritage',
    'Pantry / Panel Lantai3',
    'Pantry / Panel Lantai5',
    'Pantry / Panel Una²',
    'Plataran',
    'VIP Ballroom',
    'Warehouse LT2',
    'West Destination',
    'Una Una Exec Lounge',
    'Una Una GD',
    'The Heritage',
    'Xenon'
  ];

  // Define a list of statuses that represent "not occupied."
  final List<String> notOccupiedStatuses = [
    'not use',
    'FO Office',
    'Warehouse LT2',
    'Pantry / Panel Una²',
    'Pantry / Panel Lantai5',
    'Pantry / Panel Lantai3',
    'Pantry / Panel Heritage',
  ];

  Future<List<Map<String, dynamic>>> fetchAVDevices() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('avdevices').get();
      List<Map<String, dynamic>> avdevices = snapshot.docs.map((doc) {
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
      return avdevices;
    } catch (e) {
      log("Error fetching avdevices: $e");
      return [];
    }
  }

  Future<void> updateStatus(String avdeviceId, String newStatus) async {
    final now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('avdevices')
        .doc(avdeviceId)
        .update({
      'status': newStatus,
      'lastUpdated': now, // Update timestamp
    });
  }

  Future<void> updateAVDevice(String id, String model, String sn,
      String base64Image, String status) async {
    try {
      await FirebaseFirestore.instance.collection('avdevices').doc(id).update({
        'model': model,
        'sn': sn,
        'status': status,
        'image': base64Image, // Save base64 image string
        'lastUpdated': FieldValue.serverTimestamp(), // Update timestamp on edit
      });
      setState(() {});
    } catch (e) {
      log("Error updating avdevice: $e");
    }
  }

  Future<void> deleteAVDevice(String id) async {
    try {
      await FirebaseFirestore.instance.collection('avdevices').doc(id).delete();
      setState(() {});
    } catch (e) {
      log("Error deleting avdevice: $e");
    }
  }

  Future<void> addAVDevice(String model, String sn, String base64Image) async {
    try {
      await FirebaseFirestore.instance.collection('avdevices').add({
        'model': model,
        'sn': sn,
        'status': 'not use',
        'image': base64Image, // Save base64 image string
        'lastUpdated':
            FieldValue.serverTimestamp(), // Add timestamp when adding
      });
      setState(() {});
    } catch (e) {
      log("Error adding avdevice: $e");
    }
  }

  Future<void> _showAddAVDeviceDialog() async {
    final TextEditingController modelController = TextEditingController();
    final TextEditingController snController = TextEditingController();
    String? base64Image;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New AVDevice'),
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
                  addAVDevice(
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

  Future<void> _showDeleteConfirmationDialog(String avdeviceId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete AVDevice'),
          content: const Text('Are you sure you want to delete this avdevice?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteAVDevice(avdeviceId); // Perform delete action
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

  Future<void> _showEditAVDeviceDialog(Map<String, dynamic> avdevice) async {
    final TextEditingController modelController =
        TextEditingController(text: avdevice['model']);
    final TextEditingController snController =
        TextEditingController(text: avdevice['sn']);
    String? base64Image = avdevice['image'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit AVDevice'),
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
                  updateAVDevice(avdevice['id'], modelController.text,
                      snController.text, base64Image!, avdevice['status']);
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

  // Helper method to build avdevice card
  Widget _buildAVDeviceCard(Map<String, dynamic> avdevice) {
    final lastUpdated = avdevice['lastUpdated']?.toDate();
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
    ].contains(avdevice['status'])
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
              base64Decode(avdevice['image'] ?? ''),
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
                    '${avdevice['model']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('SN: ${avdevice['sn']}'),
                  Text(
                    notOccupiedStatuses.contains(avdevice['status'])
                        ? 'Not Occupied / @AV_Warehouse'
                        : 'Occupied @${avdevice['status']}',
                    style: TextStyle(
                      color: notOccupiedStatuses.contains(avdevice['status'])
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Text(
                    'Last Updated: $formattedDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                    value: avdevice['status'],
                    onChanged: (newValue) {
                      if (newValue != null) {
                        updateStatus(avdevice['id'], newValue);
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
                  _showEditAVDeviceDialog(avdevice);
                } else if (value == 'Delete') {
                  _showDeleteConfirmationDialog(avdevice['id']);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                const PopupMenuItem(value: 'Delete', child: Text('Delete')),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('avdevices').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No avdevices found.'));
          } else {
            // Extract and categorize avdevices
            final avdevices = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                ...data,
              };
            }).toList();

            // Categorize avdevices
            final occupiedAVDevices = avdevices
                .where((avdevice) =>
                    !notOccupiedStatuses.contains(avdevice['status']))
                .toList();

            final notOccupiedAVDevices = avdevices
                .where((avdevice) =>
                    notOccupiedStatuses.contains(avdevice['status']))
                .toList();

            return ListView(
              children: [
                if (occupiedAVDevices.isNotEmpty) ...[
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
                  ...occupiedAVDevices.map((avdevice) {
                    return _buildAVDeviceCard(avdevice);
                  }).toList(),
                ],
                if (notOccupiedAVDevices.isNotEmpty) ...[
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
                  ...notOccupiedAVDevices.map((avdevice) {
                    return _buildAVDeviceCard(avdevice);
                  }).toList(),
                ],
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAVDeviceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
