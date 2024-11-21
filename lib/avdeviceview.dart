import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

// Your AVDevices Management Page

class AVDevicePage extends StatefulWidget {
  const AVDevicePage({super.key});

  @override
  State<AVDevicePage> createState() => _AVDevicePageState();
}

class _AVDevicePageState extends State<AVDevicePage> {
  final List<String> roomOptions = [
    'not use',
    'Grand Ballroom',
    'Ballroom A',
    'Ballroom B',
    'VIP Ballroom',
    'Plataran',
    'Grand Destination',
    'Main Destination',
    'West Destination',
    'East Destination',
    'Una Una GD',
    'Una Una Exec Lounge',
    'Atmosphere',
    'Grand Argon',
    'Argon I',
    'Argon II',
    'Oxygen',
    'Hydrogen',
    'Nitrogen',
    'Helium',
    'Crypton',
    'Neon',
    'Xenon',
    'Food Exchange',
    'The Heritage',
    'FO Office'
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

  Future<void> updateStatus(String avdevicesId, String newStatus) async {
    final now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('avdevices')
        .doc(avdevicesId)
        .update({
      'status': newStatus,
      'lastUpdated': now, // Update timestamp
    });
  }

  Future<void> updateAVDevices(String id, String model, String sn,
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
      log("Error updating avdevices: $e");
    }
  }

  Future<void> deleteAVDevices(String id) async {
    try {
      await FirebaseFirestore.instance.collection('avdevices').doc(id).delete();
      setState(() {});
    } catch (e) {
      log("Error deleting avdevices: $e");
    }
  }

  Future<void> addAVDevices(String model, String sn, String base64Image) async {
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
      log("Error adding avdevices: $e");
    }
  }

  Future<void> _showAddAVDevicesDialog() async {
    final TextEditingController modelController = TextEditingController();
    final TextEditingController snController = TextEditingController();
    String? base64Image;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New AVDevices'),
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
                  addAVDevices(
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

  Future<void> _showDeleteConfirmationDialog(String avdevicesId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete AVDevices'),
          content:
              const Text('Are you sure you want to delete this avdevices?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteAVDevices(avdevicesId); // Perform delete action
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

  Future<void> _showEditAVDevicesDialog(Map<String, dynamic> avdevices) async {
    final TextEditingController modelController =
        TextEditingController(text: avdevices['model']);
    final TextEditingController snController =
        TextEditingController(text: avdevices['sn']);
    String? base64Image = avdevices['image'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit AVDevices'),
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
                  updateAVDevices(avdevices['id'], modelController.text,
                      snController.text, base64Image!, avdevices['status']);
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

  // Helper method to build avdevices card
  Widget _buildAVDevicesCard(Map<String, dynamic> avdevices) {
    final lastUpdated = avdevices['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm:ss').format(lastUpdated)
        : 'Unknown';
    Color cardColor =
        avdevices['status'] == 'not use' ? Colors.green.shade100 : Colors.white;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.memory(
              base64Decode(avdevices['image'] ?? ''),
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
                    '${avdevices['model']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('SN: ${avdevices['sn']}'),
                  if (avdevices['status'] != 'not use')
                    Text(
                      'Occupied @${avdevices['status']}',
                      style: const TextStyle(color: Colors.red),
                    )
                  else
                    const Text(
                      'Not Occupied / @AV_Warehouse',
                      style: TextStyle(color: Colors.green),
                    ),
                  Text(
                    'Last Updated: $formattedDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                    value: avdevices['status'],
                    onChanged: (newValue) {
                      if (newValue != null) {
                        updateStatus(avdevices['id'], newValue);
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
                  _showEditAVDevicesDialog(avdevices);
                } else if (value == 'Delete') {
                  _showDeleteConfirmationDialog(avdevices['id']);
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

            final occupiedAVDevices = avdevices
                .where((avdevices) => avdevices['status'] != 'not use')
                .toList();
            final notOccupiedAVDevices = avdevices
                .where((avdevices) => avdevices['status'] == 'not use')
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
                  ...occupiedAVDevices.map((avdevices) {
                    return _buildAVDevicesCard(avdevices);
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
                  ...notOccupiedAVDevices.map((avdevices) {
                    return _buildAVDevicesCard(avdevices);
                  }).toList(),
                ],
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAVDevicesDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
