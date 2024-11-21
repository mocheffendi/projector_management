import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

// Your Sound Management Page

class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
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

  Future<List<Map<String, dynamic>>> fetchSounds() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('sounds').get();
      List<Map<String, dynamic>> sounds = snapshot.docs.map((doc) {
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
      return sounds;
    } catch (e) {
      log("Error fetching sounds: $e");
      return [];
    }
  }

  Future<void> updateStatus(String soundId, String newStatus) async {
    final now = DateTime.now();
    await FirebaseFirestore.instance.collection('sounds').doc(soundId).update({
      'status': newStatus,
      'lastUpdated': now, // Update timestamp
    });
  }

  Future<void> updateSound(String id, String model, String sn,
      String base64Image, String status) async {
    try {
      await FirebaseFirestore.instance.collection('sounds').doc(id).update({
        'model': model,
        'sn': sn,
        'status': status,
        'image': base64Image, // Save base64 image string
        'lastUpdated': FieldValue.serverTimestamp(), // Update timestamp on edit
      });
      setState(() {});
    } catch (e) {
      log("Error updating sound: $e");
    }
  }

  Future<void> deleteSound(String id) async {
    try {
      await FirebaseFirestore.instance.collection('sounds').doc(id).delete();
      setState(() {});
    } catch (e) {
      log("Error deleting sound: $e");
    }
  }

  Future<void> addSound(String model, String sn, String base64Image) async {
    try {
      await FirebaseFirestore.instance.collection('sounds').add({
        'model': model,
        'sn': sn,
        'status': 'not use',
        'image': base64Image, // Save base64 image string
        'lastUpdated':
            FieldValue.serverTimestamp(), // Add timestamp when adding
      });
      setState(() {});
    } catch (e) {
      log("Error adding sound: $e");
    }
  }

  Future<void> _showAddSoundDialog() async {
    final TextEditingController modelController = TextEditingController();
    final TextEditingController snController = TextEditingController();
    String? base64Image;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Sound'),
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
                  addSound(
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

  Future<void> _showDeleteConfirmationDialog(String soundId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Sound'),
          content: const Text('Are you sure you want to delete this sound?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteSound(soundId); // Perform delete action
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

  Future<void> _showEditSoundDialog(Map<String, dynamic> sound) async {
    final TextEditingController modelController =
        TextEditingController(text: sound['model']);
    final TextEditingController snController =
        TextEditingController(text: sound['sn']);
    String? base64Image = sound['image'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Sound'),
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
                  updateSound(sound['id'], modelController.text,
                      snController.text, base64Image!, sound['status']);
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

  // Helper method to build sound card
  Widget _buildSoundCard(Map<String, dynamic> sound) {
    final lastUpdated = sound['lastUpdated']?.toDate();
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
    ].contains(sound['status'])
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
              base64Decode(sound['image'] ?? ''),
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
                    '${sound['model']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('SN: ${sound['sn']}'),
                  Text(
                    notOccupiedStatuses.contains(sound['status'])
                        ? 'Not Occupied / @AV_Warehouse'
                        : 'Occupied @${sound['status']}',
                    style: TextStyle(
                      color: notOccupiedStatuses.contains(sound['status'])
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Text(
                    'Last Updated: $formattedDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                    value: sound['status'],
                    onChanged: (newValue) {
                      if (newValue != null) {
                        updateStatus(sound['id'], newValue);
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
                  _showEditSoundDialog(sound);
                } else if (value == 'Delete') {
                  _showDeleteConfirmationDialog(sound['id']);
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
        stream: FirebaseFirestore.instance.collection('sounds').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No sounds found.'));
          } else {
            // Extract and categorize sounds
            final sounds = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                ...data,
              };
            }).toList();

            // Categorize sounds
            final occupiedSounds = sounds
                .where(
                    (sound) => !notOccupiedStatuses.contains(sound['status']))
                .toList();

            final notOccupiedSounds = sounds
                .where((sound) => notOccupiedStatuses.contains(sound['status']))
                .toList();

            return ListView(
              children: [
                if (occupiedSounds.isNotEmpty) ...[
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
                  ...occupiedSounds.map((sound) {
                    return _buildSoundCard(sound);
                  }).toList(),
                ],
                if (notOccupiedSounds.isNotEmpty) ...[
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
                  ...notOccupiedSounds.map((sound) {
                    return _buildSoundCard(sound);
                  }).toList(),
                ],
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSoundDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
