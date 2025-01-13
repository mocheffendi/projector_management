import 'dart:convert';
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
import 'package:projector_management/utility/fetchsetting.dart';

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
    fetchSettings();
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
                style: const TextStyle(),
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
              // Container(
              //   padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.grey,
              //     ),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: DropdownButton<String>(
              //     value: device['status'],
              //     underline: Container(height: 2, color: Colors.transparent),
              //     isExpanded: true,
              //     onChanged: (newValue) {
              //       device['status'] = newValue;
              //       log('Selected value: ${device['status']}');
              //       setState(() {
              //         if (newValue != null) {
              //           updateStatus(device['id'], newValue);
              //         }
              //       });

              //       Navigator.pop(context);
              //       // updateStatus(device['id'], newValue);
              //     },
              //     items: (categorizedOptions.entries
              //             .toList() // Convert entries to a list for sorting
              //           ..sort((a, b) => a.key.compareTo(
              //               b.key))) // Sort categories alphabetically
              //         .expand((entry) {
              //       final category = entry.key;
              //       final items = entry.value
              //         ..sort((a, b) => a.compareTo(b)); // Sort items descending
              //       return [
              //         DropdownMenuItem<String>(
              //           enabled: false,
              //           child: Text(
              //             category,
              //             style: const TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black,
              //             ),
              //           ),
              //         ),
              //         ...items.map(
              //           (item) => DropdownMenuItem<String>(
              //             value: item,
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 16.0),
              //               child: Row(
              //                 children: [
              //                   CircleAvatar(
              //                     radius: 12,
              //                     backgroundColor:
              //                         Colors.blue, // Icon background color
              //                     child: Text(
              //                       item
              //                           .substring(0, 2)
              //                           .toUpperCase(), // Two initial letters
              //                       style: const TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(width: 8),
              //                   Text(
              //                     item,
              //                     softWrap:
              //                         true, // Mengizinkan teks membungkus ke baris berikutnya
              //                     overflow: TextOverflow
              //                         .visible, // Overflow tidak dipotong
              //                     maxLines:
              //                         null, // Tidak ada batasan jumlah baris
              //                   ), // Display item name
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ];
              //     }).toList(),
              //   ),
              // ),
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
    final TextEditingController conditionController = TextEditingController();
    final TextEditingController remarkController = TextEditingController();
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
                controller: conditionController,
                decoration: const InputDecoration(labelText: 'Condition'),
              ),
              TextField(
                controller: remarkController,
                decoration: const InputDecoration(labelText: 'Remark'),
              ),
              const SizedBox(
                height: 8,
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
                  'condition': conditionController.text,
                  'remark': remarkController.text,
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

  // Widget _buildDeviceCard(Map<String, dynamic> device) {
  //   final lastUpdated = device['lastUpdated']?.toDate();
  //   final formattedDate = lastUpdated != null
  //       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
  //       : 'Unknown';

  //   // final String deviceType = device['type'] ?? 'Unknown Type';
  //   final String deviceSN = device['sn'] ?? '';
  //   final String deviceModel = device['model'] ?? '';
  //   final String deviceStatus = device['status'] ?? '';
  //   final String deviceCondition = device['condition'] ?? '';
  //   final String deviceRemarks = device['remark'] ?? '';
  //   final String statusLabel;
  //   final IconData statusIcon;
  //   final Color statusColor;

  //   Color cardColor = Colors.grey.shade300;

  //   if (notOccupiedStatuses.contains(deviceStatus)) {
  //     statusLabel = 'Not Occupied';
  //     statusIcon = Icons.shopping_cart_outlined;
  //     statusColor =
  //         Theme.of(context).colorScheme.secondary; // Warna sekunder tema
  //     cardColor = Theme.of(context).colorScheme.onSecondary;
  //   } else if (serviceVendor.contains(deviceStatus)) {
  //     statusLabel = 'On Service';
  //     statusIcon = CupertinoIcons.wrench;
  //     statusColor = Theme.of(context).colorScheme.primary; // Warna primer tema
  //     cardColor = Theme.of(context).colorScheme.onPrimary;
  //   } else {
  //     statusLabel = 'Occupied';
  //     statusIcon = Icons.meeting_room;
  //     statusColor = Theme.of(context).colorScheme.tertiary; // Warna error tema
  //     cardColor = Theme.of(context).colorScheme.onTertiary;
  //   }

  //   return Card(
  //     elevation: 8.0,
  //     color: cardColor,
  //     margin: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Stack(
  //             children: [
  //               Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.fromLTRB(32, 4, 32, 4),
  //                     child: Container(
  //                       width: double.infinity,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(8),
  //                           border: Border.all(color: Colors.grey)),
  //                       padding: const EdgeInsets.all(
  //                           4.0), // Padding internal untuk jarak
  //                       child: Column(
  //                         children: [
  //                           Text(
  //                             deviceModel,
  //                             style: Theme.of(context).textTheme.bodyLarge,
  //                             // const TextStyle(
  //                             //     fontSize: 16, fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Row(
  //                     children: [
  //                       device['image'] != null && device['image']!.isNotEmpty
  //                           ? Image.memory(
  //                               base64Decode(device['image']),
  //                               width: 150,
  //                               height: 100,
  //                               fit: BoxFit.fitWidth,
  //                             )
  //                           : const Icon(Icons.image_not_supported, size: 100),
  //                       const SizedBox(width: 10),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 const Icon(Icons.info_outline_rounded),
  //                                 Text('SN: $deviceSN'),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 const Icon(Icons.monitor_heart_rounded),
  //                                 Text('Condition: $deviceCondition'),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 const Icon(Icons.timer_rounded),
  //                                 Expanded(child: Text(deviceRemarks)),
  //                               ],
  //                             ),
  //                             // Text('Type: $deviceType'),
  //                             Row(
  //                               children: [
  //                                 Icon(statusIcon),
  //                                 Expanded(
  //                                   child: Text(
  //                                     "$statusLabel: @$deviceStatus",
  //                                     style: TextStyle(color: statusColor),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),

  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       const Icon(Icons.calendar_month_rounded),
  //                       Text(
  //                         'Last Updated: $formattedDate',
  //                         style: Theme.of(context).textTheme.bodySmall,
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                       padding: const EdgeInsets.fromLTRB(32, 4, 32, 4),
  //                       child: Container(
  //                         padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.grey),
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: DropdownButton<String>(
  //                           value: categorizedOptions.values
  //                                   .expand((e) => e)
  //                                   .contains(device['status'])
  //                               ? device['status']
  //                               : null, // Default to null if value is not in items
  //                           underline:
  //                               Container(height: 2, color: Colors.transparent),
  //                           isExpanded: true,
  //                           onChanged: (newValue) {
  //                             if (newValue != null) {
  //                               updateStatus(device['id'], newValue);
  //                             }
  //                           },
  //                           items: (categorizedOptions.entries.toList()
  //                                 ..sort((a, b) => a.key.compareTo(
  //                                     b.key))) // Sort categories alphabetically
  //                               .expand((entry) {
  //                             final category = entry.key;
  //                             final items = entry.value
  //                               ..sort((a, b) => a.compareTo(b));
  //                             return [
  //                               DropdownMenuItem<String>(
  //                                 enabled: false,
  //                                 child: Text(
  //                                   category,
  //                                   style: const TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.black,
  //                                   ),
  //                                 ),
  //                               ),
  //                               ...items.map((item) => DropdownMenuItem<String>(
  //                                     value: item,
  //                                     child: Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(left: 16.0),
  //                                       child: Row(
  //                                         children: [
  //                                           CircleAvatar(
  //                                             backgroundColor: Colors.blue,
  //                                             child: Text(
  //                                               getInitials(item),
  //                                               style: const TextStyle(
  //                                                   color: Colors.white),
  //                                             ),
  //                                           ),
  //                                           const SizedBox(width: 8),
  //                                           Expanded(
  //                                             child: Text(
  //                                               item,
  //                                               softWrap: true,
  //                                               overflow: TextOverflow.visible,
  //                                               maxLines: null,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   )),
  //                             ];
  //                           }).toList(),
  //                         ),
  //                       )),
  //                 ],
  //               ),
  //               Positioned(
  //                 top: -5,
  //                 right: -10,
  //                 child: PopupMenuButton<String>(
  //                   onSelected: (value) {
  //                     if (value == 'Edit') {
  //                       _showEditDeviceDialog(device);
  //                     } else if (value == 'Delete') {
  //                       _showDeleteConfirmationDialog(device['id']);
  //                     }
  //                   },
  //                   itemBuilder: (context) => [
  //                     const PopupMenuItem(
  //                       value: 'Edit',
  //                       child: Row(
  //                         children: [
  //                           Icon(Icons.edit_note),
  //                           SizedBox(width: 8),
  //                           Text('Edit'),
  //                         ],
  //                       ),
  //                     ),
  //                     const PopupMenuItem(
  //                       value: 'Delete',
  //                       child: Row(
  //                         children: [
  //                           Icon(Icons.delete),
  //                           SizedBox(width: 8),
  //                           Text('Delete'),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           if (device['additionalAttributes'] != null)
  //             ...device['additionalAttributes'].entries.map<Widget>((entry) {
  //               return Text('${entry.key}: ${entry.value}');
  //             }).toList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDeviceCard(Map<String, dynamic> device) {
  //   final lastUpdated = device['lastUpdated']?.toDate();
  //   final formattedDate = lastUpdated != null
  //       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
  //       : 'Unknown';

  //   final String deviceModel = device['model'] ?? 'Unknown Model';
  //   final String deviceSN = device['sn'] ?? '';
  //   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
  //   final String deviceStatus = device['status'] ?? 'Unknown Status';
  //   final String deviceRemarks = device['remark'] ?? '';
  //   final Color statusColor = deviceStatus == 'Occupied'
  //       ? Colors.red
  //       : deviceStatus == 'Not Occupied'
  //           ? Colors.green
  //           : Colors.blue;

  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16.0),
  //       gradient: LinearGradient(
  //         colors: [
  //           statusColor.withOpacity(0.2),
  //           Colors.white,
  //         ],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Header
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 deviceModel,
  //                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  //                       fontWeight: FontWeight.bold,
  //                       color: statusColor,
  //                     ),
  //               ),
  //               PopupMenuButton<String>(
  //                 onSelected: (value) {
  //                   if (value == 'Edit') {
  //                     _showEditDeviceDialog(device);
  //                   } else if (value == 'Delete') {
  //                     _showDeleteConfirmationDialog(device['id']);
  //                   }
  //                 },
  //                 itemBuilder: (context) => [
  //                   const PopupMenuItem(
  //                     value: 'Edit',
  //                     child: Row(
  //                       children: [
  //                         Icon(Icons.edit),
  //                         SizedBox(width: 8),
  //                         Text('Edit'),
  //                       ],
  //                     ),
  //                   ),
  //                   const PopupMenuItem(
  //                     value: 'Delete',
  //                     child: Row(
  //                       children: [
  //                         Icon(Icons.delete),
  //                         SizedBox(width: 8),
  //                         Text('Delete'),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           // Image & Status
  //           Row(
  //             children: [
  //               device['image'] != null && device['image']!.isNotEmpty
  //                   ? ClipRRect(
  //                       borderRadius: BorderRadius.circular(8.0),
  //                       child: Image.memory(
  //                         base64Decode(device['image']),
  //                         width: 100,
  //                         height: 80,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     )
  //                   : Icon(Icons.devices,
  //                       size: 80, color: Colors.grey.shade400),
  //               const SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'SN: $deviceSN',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       'Condition: $deviceCondition',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       'Remarks: $deviceRemarks',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const Divider(height: 20, thickness: 1.0),
  //           // Status & Last Updated
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     deviceStatus == 'Occupied'
  //                         ? Icons.meeting_room
  //                         : Icons.check_circle,
  //                     color: statusColor,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     deviceStatus,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: statusColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.calendar_today, size: 16),
  //                   const SizedBox(width: 4),
  //                   Text(
  //                     formattedDate,
  //                     style: Theme.of(context).textTheme.bodySmall,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showDeviceDetails(Map<String, dynamic> device) {
    final String deviceModel = device['model'] ?? 'Unknown Model';
    final String deviceSN = device['sn'] ?? 'Unknown SN';
    final String deviceCondition = device['condition'] ?? 'Unknown Condition';
    final String deviceStatus = device['status'] ?? 'Unknown Status';
    final String deviceRemarks = device['remark'] ?? 'No Remarks';
    final lastUpdated = device['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
        : 'Unknown';
    final Color statusColor = deviceStatus == 'Occupied'
        ? Colors.red
        : deviceStatus == 'Not Occupied'
            ? Colors.green
            : Colors.blue;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Device Image
              Center(
                child: device['image'] != null && device['image']!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          base64Decode(device['image']),
                          width: 150,
                          height: 100,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : Icon(
                        Icons.devices_other,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
              ),
              const SizedBox(height: 16),
              // Device Details
              Text(
                'Device Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Divider(),
              Text('Model: $deviceModel',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('SN: $deviceSN',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('Condition: $deviceCondition',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('Status: $deviceStatus',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              Text('Remarks: $deviceRemarks',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text('Last Updated: $formattedDate',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditDeviceDialog(device);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmationDialog(device['id']);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showChooseRoom(Map<String, dynamic> device) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Location'),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
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
                  device['status'] = newValue;

                  setState(() {
                    if (newValue != null) {
                      updateStatus(device['id'], newValue);
                    }
                  });

                  Navigator.pop(context);
                  // updateStatus(device['id'], newValue);
                },
                items: (categorizedOptions.entries
                        .toList() // Convert entries to a list for sorting
                      ..sort((a, b) => a.key
                          .compareTo(b.key))) // Sort categories alphabetically
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
          ),
        );
      },
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    final lastUpdated = device['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
        : 'Unknown';

    final String deviceModel = device['model'] ?? 'Unknown Model';
    final String deviceSN = device['sn'] ?? '';
    final String deviceCondition = device['condition'] ?? 'Unknown Condition';
    final String deviceStatus = device['status'] ?? 'Unknown Status';
    final String deviceRemarks = device['remark'] ?? '';
    // final Color statusColor = deviceStatus == 'Occupied'
    //     ? Colors.red
    //     : deviceStatus == 'Not Occupied'
    //         ? Colors.green
    //         : Colors.blue;

    Color cardColor = Colors.grey.shade300;

    final String statusLabel;
    final IconData statusIcon;
    final Color statusColor;

    if (notOccupiedStatuses.contains(deviceStatus)) {
      statusLabel = 'Not Occupied';
      statusIcon = Icons.shopping_cart_outlined;
      statusColor =
          Theme.of(context).colorScheme.secondary; // Warna sekunder tema
      cardColor = Theme.of(context).colorScheme.onSecondary;
    } else if (serviceVendor.contains(deviceStatus)) {
      statusLabel = 'On Service';
      statusIcon = CupertinoIcons.wrench;
      statusColor = Theme.of(context).colorScheme.primary; // Warna primer tema
      cardColor = Theme.of(context).colorScheme.onPrimary;
    } else {
      statusLabel = 'Occupied';
      statusIcon = Icons.meeting_room;
      statusColor = Theme.of(context).colorScheme.tertiary; // Warna error tema
      cardColor = Theme.of(context).colorScheme.onTertiary;
    }

    return GestureDetector(
      onTap: () => _showDeviceDetails(device), // Action on tap
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onTertiaryFixed,
              statusColor.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Theme.of(context).colorScheme.tertiaryFixed,
          //     blurRadius: 10,
          //     offset: const Offset(5, 5),
          //   ),
          //   BoxShadow(
          //     color: Theme.of(context).colorScheme.onTertiaryFixed,
          //     blurRadius: 10,
          //     offset: const Offset(-5, -5),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(deviceModel,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                GestureDetector(
                  onTap: () {
                    _showChooseRoom(device);
                  },
                  child: Chip(
                    avatar: Container(
                      // padding: const EdgeInsets.all(2), // Ketebalan border
                      decoration: BoxDecoration(
                        color: Colors.white, // Warna background di luar border
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Warna border
                          width: 1, // Ketebalan border
                        ),
                      ),
                      child: CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundColor: statusColor,
                        // radius: 48,
                        child: Text(
                          getInitials(deviceStatus),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    label: Text(
                      deviceStatus,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    backgroundColor: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Image & Details
            Row(
              children: [
                // Device Image
                Hero(
                  tag: device['id'] ?? 'deviceImage',
                  child: device['image'] != null && device['image']!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            base64Decode(device['image']),
                            width: 120,
                            height: 80,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : Icon(
                          Icons.devices_other,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                ),
                const SizedBox(width: 16),
                // Device Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SN: $deviceSN',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Condition: $deviceCondition',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remarks: $deviceRemarks',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEditDeviceDialog(device),
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(
                    'Update',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDeviceCard(Map<String, dynamic> device) {
  //   final lastUpdated = device['lastUpdated']?.toDate();
  //   final formattedDate = lastUpdated != null
  //       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
  //       : 'Unknown';

  //   final String deviceModel = device['model'] ?? 'Unknown Model';
  //   final String deviceSN = device['sn'] ?? '';
  //   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
  //   final String deviceStatus = device['status'] ?? 'Unknown Status';
  //   final String deviceRemarks = device['remark'] ?? '';

  //   final Color statusColor;
  //   final String statusLabel;
  //   final IconData statusIcon;

  //   if (notOccupiedStatuses.contains(deviceStatus)) {
  //     statusLabel = 'Not Occupied';
  //     statusIcon = Icons.shopping_cart_outlined;
  //     statusColor = Theme.of(context).colorScheme.secondary;
  //   } else if (serviceVendor.contains(deviceStatus)) {
  //     statusLabel = 'On Service';
  //     statusIcon = CupertinoIcons.wrench;
  //     statusColor = Theme.of(context).colorScheme.primary;
  //   } else {
  //     statusLabel = 'Occupied';
  //     statusIcon = Icons.meeting_room;
  //     statusColor = Theme.of(context).colorScheme.tertiary;
  //   }

  //   return GestureDetector(
  //     onTap: () => _showDeviceDetails(device),
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.3),
  //             blurRadius: 10,
  //             offset: const Offset(2, 4),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Device Image
  //           Center(
  //             child: Hero(
  //               tag: device['id'] ?? 'deviceImage',
  //               child: device['image'] != null && device['image']!.isNotEmpty
  //                   ? ClipRRect(
  //                       borderRadius: BorderRadius.circular(10),
  //                       child: Image.memory(
  //                         base64Decode(device['image']),
  //                         width: double.infinity,
  //                         height: 180,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     )
  //                   : Icon(
  //                       Icons.devices_other,
  //                       size: 80,
  //                       color: Colors.grey.shade400,
  //                     ),
  //             ),
  //           ),
  //           const SizedBox(height: 12),

  //           // Device Info
  //           Text(
  //             deviceModel,
  //             style: Theme.of(context).textTheme.bodyLarge,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             'SN: $deviceSN',
  //             style: Theme.of(context).textTheme.bodySmall,
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             'Condition: $deviceCondition',
  //             style: Theme.of(context).textTheme.bodySmall,
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             'Remarks: $deviceRemarks',
  //             style: Theme.of(context).textTheme.bodySmall,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           const SizedBox(height: 8),

  //           // Status
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Chip(
  //                 avatar: CircleAvatar(
  //                   backgroundColor: statusColor,
  //                   child: Icon(
  //                     statusIcon,
  //                     size: 16,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 label: Text(
  //                   deviceStatus,
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .bodySmall
  //                       ?.copyWith(color: Colors.white),
  //                 ),
  //                 backgroundColor: statusColor,
  //               ),
  //               Text(
  //                 formattedDate,
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .bodySmall
  //                     ?.copyWith(color: Colors.grey.shade600),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),

  //           // Update Button
  //           ElevatedButton.icon(
  //             onPressed: () => _showEditDeviceDialog(device),
  //             icon: const Icon(Icons.edit, size: 16),
  //             label: const Text('Update'),
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: statusColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDeviceCard(Map<String, dynamic> device) {
  //   final lastUpdated = device['lastUpdated']?.toDate();
  //   final formattedDate = lastUpdated != null
  //       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
  //       : 'Unknown';

  //   final String deviceModel = device['model'] ?? 'Unknown Model';
  //   final String deviceSN = device['sn'] ?? '';
  //   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
  //   final String deviceStatus = device['status'] ?? 'Unknown Status';
  //   final String deviceRemarks = device['remark'] ?? '';

  //   Color cardColor = Colors.grey.shade300;

  //   final String statusLabel;
  //   final IconData statusIcon;
  //   final Color statusColor;

  //   if (notOccupiedStatuses.contains(deviceStatus)) {
  //     statusLabel = 'Not Occupied';
  //     statusIcon = Icons.shopping_cart_outlined;
  //     statusColor = Theme.of(context).colorScheme.secondary;
  //     cardColor = Theme.of(context).colorScheme.onSecondary;
  //   } else if (serviceVendor.contains(deviceStatus)) {
  //     statusLabel = 'On Service';
  //     statusIcon = CupertinoIcons.wrench;
  //     statusColor = Theme.of(context).colorScheme.primary;
  //     cardColor = Theme.of(context).colorScheme.onPrimary;
  //   } else {
  //     statusLabel = 'Occupied';
  //     statusIcon = Icons.meeting_room;
  //     statusColor = Theme.of(context).colorScheme.tertiary;
  //     cardColor = Theme.of(context).colorScheme.onTertiary;
  //   }

  //   return GestureDetector(
  //     onTap: () => _showDeviceDetails(device),
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         gradient: LinearGradient(
  //           colors: [
  //             Theme.of(context).colorScheme.onTertiaryFixed,
  //             statusColor.withOpacity(0.1),
  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           // Header
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 child: Text(deviceModel,
  //                     style: Theme.of(context).textTheme.bodyLarge),
  //               ),
  //               Chip(
  //                 avatar: CircleAvatar(
  //                   backgroundColor: Colors.blue,
  //                   radius: 32,
  //                   child: Text(
  //                     getInitials(deviceStatus),
  //                     style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //                 label: Text(
  //                   deviceStatus,
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //                 backgroundColor: statusColor,
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           // Content in two vertical columns
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Left Column
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Hero(
  //                       tag: device['id'] ?? 'deviceImage',
  //                       child: device['image'] != null &&
  //                               device['image']!.isNotEmpty
  //                           ? ClipRRect(
  //                               borderRadius: BorderRadius.circular(10),
  //                               child: Image.memory(
  //                                 base64Decode(device['image']),
  //                                 width: double.infinity,
  //                                 height: 100,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             )
  //                           : Icon(
  //                               Icons.devices_other,
  //                               size: 80,
  //                               color: Colors.grey.shade400,
  //                             ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(width: 16),
  //               // Right Column
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'SN: $deviceSN',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Text(
  //                       'Condition: $deviceCondition',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Text(
  //                       'Remarks: $deviceRemarks',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                       maxLines: 3,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           // Footer
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.calendar_today,
  //                     size: 16,
  //                     color: Colors.grey.shade600,
  //                   ),
  //                   const SizedBox(width: 4),
  //                   Text(
  //                     formattedDate,
  //                     style: Theme.of(context).textTheme.bodySmall,
  //                   ),
  //                 ],
  //               ),
  //               ElevatedButton.icon(
  //                 onPressed: () => _showEditDeviceDialog(device),
  //                 icon: const Icon(Icons.edit, size: 16),
  //                 label: Text(
  //                   'Update',
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: statusColor,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDeviceCard(Map<String, dynamic> device) {
  //   final lastUpdated = device['lastUpdated']?.toDate();
  //   final formattedDate = lastUpdated != null
  //       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
  //       : 'Unknown';

  //   final String deviceModel = device['model'] ?? 'Unknown Model';
  //   final String deviceSN = device['sn'] ?? '';
  //   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
  //   final String deviceStatus = device['status'] ?? 'Unknown Status';
  //   final String deviceRemarks = device['remark'] ?? '';

  //   Color cardColor = Colors.grey.shade300;

  //   final String statusLabel;
  //   final IconData statusIcon;
  //   final Color statusColor;

  //   if (notOccupiedStatuses.contains(deviceStatus)) {
  //     statusLabel = 'Not Occupied';
  //     statusIcon = Icons.shopping_cart_outlined;
  //     statusColor = Theme.of(context).colorScheme.secondary;
  //     cardColor = Theme.of(context).colorScheme.onSecondary;
  //   } else if (serviceVendor.contains(deviceStatus)) {
  //     statusLabel = 'On Service';
  //     statusIcon = CupertinoIcons.wrench;
  //     statusColor = Theme.of(context).colorScheme.primary;
  //     cardColor = Theme.of(context).colorScheme.onPrimary;
  //   } else {
  //     statusLabel = 'Occupied';
  //     statusIcon = Icons.meeting_room;
  //     statusColor = Theme.of(context).colorScheme.tertiary;
  //     cardColor = Theme.of(context).colorScheme.onTertiary;
  //   }

  //   return GestureDetector(
  //     onTap: () => _showDeviceDetails(device),
  //     child: Container(
  //       margin: const EdgeInsets.all(8),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         gradient: LinearGradient(
  //           colors: [
  //             Theme.of(context).colorScheme.onTertiaryFixed,
  //             statusColor.withOpacity(0.1),
  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Header
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 child: Text(deviceModel,
  //                     style: Theme.of(context).textTheme.bodyLarge),
  //               ),
  //               Chip(
  //                 avatar: CircleAvatar(
  //                   backgroundColor: Colors.blue,
  //                   radius: 32,
  //                   child: Text(
  //                     getInitials(deviceStatus),
  //                     style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //                 label: Text(
  //                   deviceStatus,
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //                 backgroundColor: statusColor,
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           // Device Image
  //           Hero(
  //             tag: device['id'] ?? 'deviceImage',
  //             child: device['image'] != null && device['image']!.isNotEmpty
  //                 ? ClipRRect(
  //                     borderRadius: BorderRadius.circular(10),
  //                     child: Image.memory(
  //                       base64Decode(device['image']),
  //                       width: double.infinity,
  //                       height: 120,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   )
  //                 : Icon(
  //                     Icons.devices_other,
  //                     size: 80,
  //                     color: Colors.grey.shade400,
  //                   ),
  //           ),
  //           const SizedBox(height: 16),
  //           // Device Details
  //           Text(
  //             'SN: $deviceSN',
  //             style: Theme.of(context).textTheme.bodySmall,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             'Condition: $deviceCondition',
  //             style: Theme.of(context).textTheme.bodySmall,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             'Remarks: $deviceRemarks',
  //             style: Theme.of(context).textTheme.bodySmall,
  //             maxLines: 3,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           const SizedBox(height: 16),
  //           // Footer
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.calendar_today,
  //                     size: 16,
  //                     color: Colors.grey.shade600,
  //                   ),
  //                   const SizedBox(width: 4),
  //                   Text(
  //                     formattedDate,
  //                     style: Theme.of(context).textTheme.bodySmall,
  //                   ),
  //                 ],
  //               ),
  //               ElevatedButton.icon(
  //                 onPressed: () => _showEditDeviceDialog(device),
  //                 icon: const Icon(Icons.edit, size: 16),
  //                 label: Text(
  //                   'Update',
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: statusColor,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: StreamBuilder<QuerySnapshot>(
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
                    .where((device) =>
                        notOccupiedStatuses.contains(device['status']))
                    .toList()
                  ..sort((a, b) => a['status'].compareTo(b['status']));
                final serviceDevices = devices
                    .where((device) => serviceVendor.contains(device['status']))
                    .toList()
                  ..sort((a, b) => a['status'].compareTo(b['status']));

                // final categorizedDevices = [
                //   ...occupiedDevices,
                //   ...notOccupiedDevices,
                //   ...serviceDevices,
                // ];

                return ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (occupiedDevices.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Occupied',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      ...occupiedDevices
                          .map((device) => _buildDeviceCard(device)),
                    ],
                    if (notOccupiedDevices.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Not Occupied ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                      ...notOccupiedDevices
                          .map((device) => _buildDeviceCard(device)),
                    ],
                    if (serviceDevices.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'On Service',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                      ...serviceDevices
                          .map((device) => _buildDeviceCard(device)),
                    ],
                  ],
                );
                // return ListView.builder(
                //   shrinkWrap: true,
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: categorizedDevices.length,
                //   itemBuilder: (context, index) {
                //     return _buildDeviceCard(categorizedDevices[index]);
                //   },
                // );
                // return GridView.builder(
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 8,
                //     mainAxisSpacing: 8,
                //     childAspectRatio: 0.8,
                //   ),
                //   itemCount: devices.length,
                //   itemBuilder: (context, index) {
                //     return _buildDeviceCard(devices[index]);
                //   },
                // );
              }
            },
          ),
        ),
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
                  // ignore: use_build_context_synchronously
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
