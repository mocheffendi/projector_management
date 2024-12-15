import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projector_management/utility/generatepdfuniversal.dart';
import 'package:projector_management/utility/pdftoimage.dart';
import 'package:projector_management/widget/showdialogpdfimage.dart';
import 'package:projector_management/utility/getinitials.dart';

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

class DevicePage extends StatefulWidget {
  final String collectionName;

  const DevicePage({super.key, required this.collectionName});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config2')
          .get();

      if (snapshot.exists) {
        setState(() {
          final data = snapshot.data() as Map<String, dynamic>;
          categorizedOptions = data.map((key, value) =>
              MapEntry(key, List<String>.from(value as List<dynamic>)));
        });
      }
    } catch (e) {
      // log('Error fetching settings: $e');
    }

    roomOptions = categorizedOptions["Room"] ?? [];
    pantryPanel = categorizedOptions["Pantry/Panel"] ?? [];
    store = categorizedOptions["Store"] ?? [];
    serviceVendor = categorizedOptions["Service Vendor"] ?? [];
    notOccupiedStatuses = pantryPanel + store;
    // log("notOccupiedStatuses: $notOccupiedStatuses");
  }

  Future<void> updateStatus(String id, String newStatus) async {
    final now = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(id)
          .update({
        'status': newStatus,
        'lastUpdated': now,
      });
      // log('Status updated for $id to $newStatus');
    } catch (e) {
      // log('Error updating status: $e');
    }
  }

  Future<void> _showEditDeviceDialog(Map<String, dynamic> device) async {
    String? updatedModel = device['model'];
    String? updatedSN = device['sn'];
    String? updatedStatus = device['status'];
    String? updatedCondition = device['condition'];
    String? updatedRemark = device['remark'];
    String? base64Image = device['image'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Model'),
                controller: TextEditingController(text: updatedModel),
                onChanged: (value) => updatedModel = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'SN'),
                controller: TextEditingController(text: updatedSN),
                onChanged: (value) => updatedSN = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Condition'),
                controller: TextEditingController(text: updatedCondition),
                onChanged: (value) => updatedCondition = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'remark'),
                controller: TextEditingController(text: updatedRemark),
                onChanged: (value) => updatedRemark = value,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: device['status'],
                  underline: Container(height: 2, color: Colors.transparent),
                  isExpanded: true,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      updateStatus(device['id'], newValue);
                    }
                  },
                  items: (categorizedOptions.entries
                          .toList() // Convert entries to a list for sorting
                        ..sort((a, b) => a.key.compareTo(
                            b.key))) // Sort categories alphabetically
                      .expand((entry) {
                    final category = entry.key;
                    final items = entry.value
                      ..sort((a, b) => a.compareTo(b)); // Sort items descending
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
                      ...items.map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Colors.blue, // Icon background color
                                  child: Text(
                                    item
                                        .substring(0, 2)
                                        .toUpperCase(), // Two initial letters
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item,
                                  softWrap:
                                      true, // Mengizinkan teks membungkus ke baris berikutnya
                                  overflow: TextOverflow
                                      .visible, // Overflow tidak dipotong
                                  maxLines:
                                      null, // Tidak ada batasan jumlah baris
                                ), // Display item name
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 16,
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (updatedModel != null &&
                    updatedSN != null &&
                    updatedCondition != null &&
                    updatedRemark != null &&
                    updatedStatus != null) {
                  FirebaseFirestore.instance
                      .collection(widget.collectionName)
                      .doc(device['id'])
                      .update({
                    'model': updatedModel,
                    'sn': updatedSN,
                    'status': updatedStatus,
                    'condition': updatedCondition,
                    'remark': updatedRemark,
                    'image': base64Image,
                    'lastUpdated': Timestamp.now(),
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      elevation: 8,
                      content:
                          Text("${widget.collectionName} saved successfully"),
                    ));
                  }

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(String id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this device?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection(widget.collectionName)
                    .doc(id)
                    .delete();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addDevice(Map<String, dynamic> deviceData) async {
    try {
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .add(deviceData);
      // log('Device added: $deviceData');
    } catch (e) {
      // log('Error adding device: $e');
    }
  }

  void _showAddDeviceDialog() {
    final TextEditingController modelController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    // final TextEditingController statusController = TextEditingController();
    final TextEditingController snController = TextEditingController();
    String? base64Image;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              TextField(
                controller: snController,
                decoration: const InputDecoration(labelText: 'SN'),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type'),
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
                final newDevice = {
                  'model': modelController.text,
                  'sn': snController.text,
                  'status': 'Store LT2',
                  'image': base64Image, // Save base64 image string
                  'type': typeController.text,
                  // 'status': statusController.text,
                  'lastUpdated': Timestamp.now(),
                };
                addDevice(newDevice);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    final lastUpdated = device['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
        : 'Unknown';

    // final String deviceType = device['type'] ?? 'Unknown Type';
    final String deviceSN = device['sn'] ?? 'Unknown SN';
    final String deviceModel = device['model'] ?? 'Unknown Model';
    final String deviceStatus = device['status'] ?? 'Unknown Status';
    final String deviceCondition = device['condition'] ?? 'Unknown Condition';
    final String deviceRemarks = device['remark'] ?? 'Unknown Remark';
    final String statusLabel;
    final IconData statusIcon;
    final Color statusColor;

    Color cardColor = Colors.grey.shade300;

    if (notOccupiedStatuses.contains(deviceStatus)) {
      statusLabel = 'Not Occupied';
      statusIcon = Icons.shopping_cart_outlined;
      statusColor = Colors.green;
      cardColor = Colors.green.shade100;
    } else if (serviceVendor.contains(deviceStatus)) {
      statusLabel = 'On Service';
      statusIcon = CupertinoIcons.wrench;
      statusColor = Colors.blue;
      cardColor = Colors.blue.shade100;
    } else {
      statusLabel = 'Occupied';
      statusIcon = Icons.meeting_room;
      statusColor = Colors.redAccent.shade700;
    }

    return Card(
      elevation: 8.0,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    device['image'] != null && device['image']!.isNotEmpty
                        ? Image.memory(
                            base64Decode(device['image']),
                            width: 150,
                            height: 100,
                            fit: BoxFit.fitWidth,
                          )
                        : const Icon(Icons.image_not_supported, size: 100),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deviceModel,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('SN: $deviceSN'),
                          Text('Condition: $deviceCondition'),
                          Text(deviceRemarks),
                          // Text('Type: $deviceType'),
                          Row(
                            children: [
                              Icon(statusIcon),
                              Text(
                                "$statusLabel: @$deviceStatus",
                                softWrap:
                                    true, // Mengizinkan teks membungkus ke baris berikutnya
                                overflow: TextOverflow
                                    .visible, // Overflow tidak dipotong
                                maxLines:
                                    null, // Tidak ada batasan jumlah baris
                                style: TextStyle(color: statusColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded),
                              Text(
                                'Last Updated: $formattedDate',
                                softWrap:
                                    true, // Mengizinkan teks membungkus ke baris berikutnya
                                overflow: TextOverflow
                                    .visible, // Overflow tidak dipotong
                                maxLines:
                                    null, // Tidak ada batasan jumlah baris
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: device['status'],
                              underline: Container(
                                  height: 2, color: Colors.transparent),
                              isExpanded: true,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  updateStatus(device['id'], newValue);
                                }
                              },
                              items: (categorizedOptions.entries
                                      .toList() // Convert entries to a list for sorting
                                    ..sort((a, b) => a.key.compareTo(b
                                        .key))) // Sort categories alphabetically
                                  .expand((entry) {
                                final category = entry.key;
                                final items = entry.value
                                  ..sort((a, b) =>
                                      a.compareTo(b)); // Sort items descending
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
                                  ...items.map(
                                    (item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors
                                                  .blue, // Warna latar belakang avatar
                                              child: Text(
                                                getInitials(
                                                    item), // Fungsi untuk mendapatkan inisial dari item
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ), // Menyesuaikan warna teks
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                item,
                                                softWrap:
                                                    true, // Mengizinkan teks membungkus ke baris berikutnya
                                                overflow: TextOverflow
                                                    .visible, // Overflow tidak dipotong
                                                maxLines:
                                                    null, // Tidak ada batasan jumlah baris
                                              ),
                                            ), // Display item name
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              }).toList(),
                            ),
                          ),
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
                        _showEditDeviceDialog(device);
                      } else if (value == 'Delete') {
                        _showDeleteConfirmationDialog(device['id']);
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
            if (device['additionalAttributes'] != null)
              ...device['additionalAttributes'].entries.map<Widget>((entry) {
                return Text('${entry.key}: ${entry.value}');
              }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No devices found.'));
          } else {
            final devices = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                ...data,
              };
            }).toList();

            // Categorize and sort devices
            final occupiedDevices = devices
                .where((device) =>
                    !notOccupiedStatuses.contains(device['status']) &&
                    !serviceVendor.contains(device['status']))
                .toList()
              ..sort((a, b) => a['status'].compareTo(b['status']));
            final notOccupiedDevices = devices
                .where(
                    (device) => notOccupiedStatuses.contains(device['status']))
                .toList()
              ..sort((a, b) => a['status'].compareTo(b['status']));
            final serviceDevices = devices
                .where((device) => serviceVendor.contains(device['status']))
                .toList()
              ..sort((a, b) => a['status'].compareTo(b['status']));

            final categorizedDevices = [
              ...occupiedDevices,
              ...notOccupiedDevices,
              ...serviceDevices,
            ];

            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: categorizedDevices.length,
              itemBuilder: (context, index) {
                return _buildDeviceCard(categorizedDevices[index]);
              },
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
                // Tambah perangkat baru
                _showAddDeviceDialog();
              },
              child: const Icon(Icons.add),
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

                final pdfBytes =
                    await generatePdfandShareSupportWeb(widget.collectionName);
                Uint8List pdfBytesCopy = Uint8List.fromList(pdfBytes);
                final pngBytes = await convertPdfToPng(pdfBytes);

                // Close loading dialog
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    elevation: 8,
                    content: Text(
                        "${widget.collectionName} Pdf Generated successfully"),
                  ));
                }

                if (mounted) {
                  // ignore: use_build_context_synchronously
                  showPdfDialog(context, pdfBytesCopy, pngBytes);
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
