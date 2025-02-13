import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:projector_management/rbin/generatepdf.dart';
import 'package:projector_management/utility/pdftoimage.dart';
import 'package:projector_management/widget/showdialogpdfimage.dart';

// Your Projector Management Page
class ProjectorPage extends StatefulWidget {
  const ProjectorPage({super.key});

  @override
  State<ProjectorPage> createState() => _ProjectorPageState();
}

class _ProjectorPageState extends State<ProjectorPage> {
  final ScrollController _scrollController = ScrollController();

  Map<String, List<String>> categorizedOptions = {
    "Room": [],
    "Pantry/Panel": [],
    "Store": [],
    "Service Vendor": [],
  };

  String? selectedItem = 'DRM'; // Menyimpan item yang dipilih

  List<String> roomOptions = [];
  List<String> pantryPanel = [];
  List<String> store = [];
  List<String> notOccupiedStatuses = [];
  List<String> serviceVendor = [];

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config2')
          .get();

      if (snapshot.exists) {
        // var data = snapshot.data() as Map<String, dynamic>;
        // setState(() {
        //   roomOptions = List<String>.from(data['room']);
        //   notOccupiedStatuses = List<String>.from(data['not Occupied']);
        //   serviceVendor = List<String>.from(data['Service Vendor']);
        // });
        setState(() {
          final data = snapshot.data() as Map<String, dynamic>;
          categorizedOptions = data.map((key, value) =>
              MapEntry(key, List<String>.from(value as List<dynamic>)));
        });
      }
    } catch (e) {
      log('Error fetching settings: $e');
    }

    // log("CategorizedOptions: $categorizedOptions");
    roomOptions = categorizedOptions["Room"] ?? [];
    pantryPanel = categorizedOptions["Pantry/Panel"] ?? [];
    store = categorizedOptions["Store"] ?? [];
    // log("Room Options: $roomOptions");
    serviceVendor = categorizedOptions["Service Vendor"] ?? [];
    notOccupiedStatuses = pantryPanel + store;
    // List<String> room = roomOptions + pantryPanel + serviceVendor;
  }

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
        'status': 'Store LT2',
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

  Widget _buildProjectorCard(Map<String, dynamic> projector) {
    final lastUpdated = projector['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
        : 'Unknown';
    Color cardColor = Colors.grey.shade300; // Default color

    // Example projector status
    final String projectorStatus = projector['status'];
    final String statusLabel;
    final Color statusColor;

    if (notOccupiedStatuses.contains(projectorStatus)) {
      statusLabel = 'Not Occupied @$projectorStatus';
      statusColor = Colors.green;
      cardColor = Colors.green.shade100;
    } else if (serviceVendor.contains(projectorStatus)) {
      statusLabel = 'On Service @$projectorStatus';
      statusColor = Colors.blue;
      cardColor = Colors.blue.shade100;
    } else {
      statusLabel = 'Occupied @$projectorStatus';
      statusColor = Colors.redAccent.shade700;
    }

    return Card.filled(
      elevation: 8.0,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
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
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.date_range_rounded),
                          Text(
                            'Last Updated: $formattedDate',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // child: DropdownButton<String>(
                        //   underline: Container(
                        //     height: 2,
                        //     color: Colors.transparent,
                        //   ),
                        //   value: projector['status'],
                        //   onChanged: (newValue) {
                        //     if (newValue != null) {
                        //       updateStatus(projector['id'], newValue);
                        //     }
                        //   },
                        //   items: roomOptions.map((room) {
                        //     return DropdownMenuItem<String>(
                        //       value: room,
                        //       child: Text(room),
                        //     );
                        //   }).toList(),
                        // ),
                        child: DropdownButton<String>(
                          value: projector['status'],
                          // hint: const Text("Select an item"),
                          underline:
                              Container(height: 2, color: Colors.transparent),
                          isExpanded: true,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              updateStatus(projector['id'], newValue);
                            }
                          },
                          items: categorizedOptions.entries.expand((entry) {
                            final category = entry.key;
                            final items = entry.value;
                            // print(
                            //     "Items: ${items.map((item) => item.toString()).toList()}");
                            // Header untuk kategori (bukan value)
                            return [
                              DropdownMenuItem<String>(
                                enabled: false,
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // Daftar item dalam kategori
                              ...items.map(
                                (item) => DropdownMenuItem<String>(
                                  value: item, // Nilai unik untuk item
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(item),
                                  ),
                                ),
                              ),
                            ];
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: -5,
              right: -10,
              child: PopupMenuButton<String>(
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
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
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

            // Categorize and sort projectors
            final occupiedProjectors = projectors
                .where((projector) =>
                    !notOccupiedStatuses.contains(projector['status']) &&
                    !serviceVendor.contains(projector['status']))
                .toList()
              ..sort((a, b) => a['status'].compareTo(b['status']));
            final notOccupiedProjectors = projectors
                .where((projector) =>
                    notOccupiedStatuses.contains(projector['status']))
                .toList()
              ..sort((a, b) => a['status'].compareTo(b['status']));
            final serviceProjectors = projectors
                .where(
                    (projector) => serviceVendor.contains(projector['status']))
                .toList()
              ..sort((a, b) => a['status'].compareTo(b['status']));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                controller: _scrollController, // Attach the ScrollController
                physics:
                    const BouncingScrollPhysics(), // Add smooth scrolling physics
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
                  if (serviceProjectors.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'On Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    ...serviceProjectors.map((projector) {
                      return _buildProjectorCard(projector);
                    }).toList(),
                  ],
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: () {
                _showAddProjectorDialog();
              },
              child: const Icon(Icons.add_box),
            ),
          ),
          Positioned(
            bottom: 65,
            right: 0,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              mini: true,
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Generating PDF..."),
                          ],
                        ),
                      ),
                    );
                  },
                );

                final pdfBytes = await generatePdfandShareSupportWeb();
                Uint8List pdfBytesCopy = Uint8List.fromList(pdfBytes);
                final pngBytes = await convertPdfToPng(pdfBytes);

                // Close loading dialog
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }

                if (mounted) {
                  // ignore: use_build_context_synchronously
                  showPdfBottomSheet(context, pdfBytesCopy, pngBytes);
                }
              },
              child: const Icon(Icons.screen_share_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

// void _showSharedToast(BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text('Document shared successfully'),
//     ),
//   );
// }
