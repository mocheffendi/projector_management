// import 'dart:async';
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:projector_management/utility/fetchsetting.dart';

// Future<pw.Font> loadFont(String path) async {
//   final fontData = await rootBundle.load(path);
//   return pw.Font.ttf(fontData);
// }

// Future<List<pw.Widget>> _buildAllDeviceCards(List<Map<String, dynamic>> devices, Uint8List info,
//     Uint8List condition, Uint8List time, Uint8List status, Uint8List calendar, pw.Font font) async {
//   List<pw.Widget> deviceCards = [];
//   for (var device in devices) {
//     final card = await _buildDeviceCardpw(device, info, condition, time, status, calendar, font);
//     deviceCards.add(card);
//   }
//   return deviceCards;
// }

// Future<Uint8List> generatePdfandShareSupportWeb(String device) async {
//   final pdf = pw.Document();
//   final font = await loadFont('assets/fonts/Roboto-Regular.ttf');

//   final Uint8List info =
//       (await rootBundle.load('assets/png/info.png')).buffer.asUint8List();
//   final Uint8List store =
//       (await rootBundle.load('assets/png/store.png')).buffer.asUint8List();
//   final Uint8List hotel =
//       (await rootBundle.load('assets/png/hotel.png')).buffer.asUint8List();
//   final Uint8List service =
//       (await rootBundle.load('assets/png/screwdriver_wrench.png'))
//           .buffer
//           .asUint8List();
//   final Uint8List time =
//       (await rootBundle.load('assets/png/stopwatch.png')).buffer.asUint8List();
//   final Uint8List condition =
//       (await rootBundle.load('assets/png/wave_square.png'))
//           .buffer
//           .asUint8List();
//   final Uint8List calendar =
//       (await rootBundle.load('assets/png/calendar.png')).buffer.asUint8List();

//   // Fetch data from Firestore
//   final querySnapshot =
//       await FirebaseFirestore.instance.collection(device).get();
//   final devices = querySnapshot.docs.map((doc) {
//     final data = doc.data();
//     return {
//       'id': doc.id,
//       ...data,
//     };
//   }).toList();

//   await fetchSettings();

//   // Example statuses
//   final occupieddevices = devices
//       .where((device) =>
//           !notOccupiedStatuses.contains(device['status']) &&
//           !serviceVendor.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   final notOccupieddevices = devices
//       .where((device) => notOccupiedStatuses.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   final servicedevices = devices
//       .where((device) => serviceVendor.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   // Add data to PDF
//   if ((occupieddevices.isNotEmpty) ||
//       (notOccupieddevices.isNotEmpty) ||
//       (servicedevices.isNotEmpty)) {
//     pdf.addPage (
//       pw.Page(
//         pageFormat: const PdfPageFormat(400, double.infinity, marginAll: 8.0),
//         build: (pw.Context context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Occupied $device',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.red,
//                 font: font,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...await _buildAllDeviceCards(occupieddevices, info, condition, time, hotel, calendar, font),
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'Not Occupied $device',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.green,
//                 font: font,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...await _buildAllDeviceCards(notOccupieddevices, info, condition, time, store, calendar, font),
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'On Service',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.blue,
//                 font: font,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...await _buildAllDeviceCards(servicedevices, info, condition, time, service, calendar, font),
//           ],
//         ),
//       ),
//     );
//   }

//   final pdfBytes = await pdf.save();

//   return pdfBytes;
// }

// Future<Uint8List> generatePdfandShareSupportWeb(String device) async {
//   final pdf = pw.Document();
//   final font = await loadFont('assets/fonts/Roboto-Regular.ttf');

//   final Uint8List info =
//       (await rootBundle.load('assets/png/info.png')).buffer.asUint8List();
//   final Uint8List store =
//       (await rootBundle.load('assets/png/store.png')).buffer.asUint8List();
//   final Uint8List hotel =
//       (await rootBundle.load('assets/png/hotel.png')).buffer.asUint8List();
//   final Uint8List service =
//       (await rootBundle.load('assets/png/screwdriver_wrench.png'))
//           .buffer
//           .asUint8List();
//   final Uint8List time =
//       (await rootBundle.load('assets/png/stopwatch.png')).buffer.asUint8List();
//   final Uint8List condition =
//       (await rootBundle.load('assets/png/wave_square.png'))
//           .buffer
//           .asUint8List();
//   final Uint8List calendar =
//       (await rootBundle.load('assets/png/calendar.png')).buffer.asUint8List();

//   // Fetch data from Firestore
//   final querySnapshot =
//       await FirebaseFirestore.instance.collection(device).get();
//   final devices = querySnapshot.docs.map((doc) {
//     final data = doc.data();
//     return {
//       'id': doc.id,
//       ...data,
//     };
//   }).toList();

//   await fetchSettings();

//   // Example statuses
//   final occupieddevices = devices
//       .where((device) =>
//           !notOccupiedStatuses.contains(device['status']) &&
//           !serviceVendor.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   final notOccupieddevices = devices
//       .where((device) => notOccupiedStatuses.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   final servicedevices = devices
//       .where((device) => serviceVendor.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   // Add data to PDF
//   if ((occupieddevices.isNotEmpty) ||
//       (notOccupieddevices.isNotEmpty) ||
//       (servicedevices.isNotEmpty)) {
//     pdf.addPage(
//       pw.Page(
//         pageFormat: const PdfPageFormat(400, double.infinity, marginAll: 8.0),
//         build: (pw.Context context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Occupied $device',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.red,
//                 font: font,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...occupieddevices.map((device) {
//               return pw.Container(
//                 margin: const pw.EdgeInsets.only(bottom: 5),
//                 child: _builddeviceCardpw(
//                     device, info, condition, time, hotel, calendar),
//               );
//             }).toList(),
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'Not Occupied $device',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.green,
//                 font: font,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...notOccupieddevices.map((device) {
//               return pw.Container(
//                 margin: const pw.EdgeInsets.only(bottom: 5),
//                 child: _builddeviceCardpw(
//                     device, info, condition, time, store, calendar),
//               );
//             }).toList(),
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'On Service',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.blue,
//                 font: font,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...servicedevices.map((device) {
//               return pw.Container(
//                 margin: const pw.EdgeInsets.only(bottom: 5),
//                 child: _builddeviceCardpw(
//                     device, info, condition, time, service, calendar),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   final pdfBytes = await pdf.save();

//   return pdfBytes;
// }

// pw.Widget _builddeviceCardpw(Map<String, dynamic> device, Uint8List info,
//     Uint8List condition, Uint8List time, Uint8List status, Uint8List calendar) {
//   final lastUpdated = device['lastUpdated']?.toDate();
//   final formattedDate = lastUpdated != null
//       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
//       : 'Unknown';

//   // final font = await loadFont('assets/fonts/Roboto-Regular.ttf');
//   PdfColor cardColor = PdfColors.red;

//   final String deviceModel = device['model'] ?? 'Unknown Model';
//   final String deviceSN = device['sn'] ?? '';
//   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
//   final String deviceStatus = device['status'] ?? 'Unknown Status';
//   final String deviceRemarks = device['remark'] ?? '';

//   final String statusLabel;
//   final PdfColor statusColor;

//   if (notOccupiedStatuses.contains(deviceStatus)) {
//     statusLabel = 'Not Occupied @$deviceStatus';
//     statusColor = PdfColors.green;
//     cardColor = PdfColors.green;
//   } else if (serviceVendor.contains(deviceStatus)) {
//     statusLabel = 'Service @$deviceStatus';
//     statusColor = PdfColors.blue;
//     cardColor = PdfColors.blue;
//   } else {
//     statusLabel = 'Occupied @$deviceStatus';
//     statusColor = PdfColors.red;
//   }

//   return pw.Container(
//     margin: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//     padding: const pw.EdgeInsets.all(8),
//     decoration: pw.BoxDecoration(
//       borderRadius: pw.BorderRadius.circular(20),
//       gradient: pw.LinearGradient(
//         colors: [
//           PdfColors.white,
//           cardColor,
//         ],
//         begin: pw.Alignment.topLeft,
//         end: pw.Alignment.bottomRight,
//       ),
//     ),
//     child: pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         // Header
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//           children: [
//             pw.Expanded(
//               child: pw.Text(deviceModel,
//                   style: pw.TextStyle(
//                       // font: font,
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold)),
//             ),
//             pw.Container(
//               padding: const pw.EdgeInsets.all(4),
//               decoration: pw.BoxDecoration(
//                 color: statusColor,
//                 borderRadius: pw.BorderRadius.circular(8),
//                 border: pw.Border.all(
//                   color: PdfColors.white,
//                   width: 1,
//                 ),
//               ),
//               child: pw.Text(
//                 deviceStatus,
//                 style: pw.TextStyle(
//                   // font: font,
//                   color: PdfColors.white,
//                   fontSize: 12,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 8),
//         // Image & Details
//         pw.Row(
//           children: [
//             // Device Image
//             device['image'] != null && device['image']!.isNotEmpty
//                 ? pw.Image(
//                     pw.MemoryImage(base64Decode(device['image'])),
//                     width: 120,
//                     height: 80,
//                     fit: pw.BoxFit.fitWidth,
//                   )
//                 : pw.Container(
//                     width: 120,
//                     height: 80,
//                     decoration:
//                         const pw.BoxDecoration(color: PdfColors.grey300),
//                     child: pw.Center(child: pw.Text("No Image")),
//                   ),
//             pw.SizedBox(width: 16),
//             // Device Info
//             pw.Expanded(
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'SN: $deviceSN',
//                     style: const pw.TextStyle(
//                         // font: font,
//                         fontSize: 12,
//                         color: PdfColors.black),
//                   ),
//                   pw.SizedBox(height: 4),
//                   pw.Text(
//                     'Condition: $deviceCondition',
//                     style: const pw.TextStyle(
//                         // font: font,
//                         fontSize: 12,
//                         color: PdfColors.black),
//                   ),
//                   pw.SizedBox(height: 4),
//                   pw.Text(
//                     'Remarks: $deviceRemarks',
//                     style: const pw.TextStyle(
//                         // font: font,
//                         fontSize: 12,
//                         color: PdfColors.black),
//                     maxLines: 2,
//                     // overflow: pw.TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 16),
//         // Footer
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Row(
//               children: [
//                 pw.Text(
//                   'Last Updated: ',
//                   style: const pw.TextStyle(
//                       // font: font,
//                       fontSize: 12,
//                       color: PdfColors.black),
//                 ),
//                 pw.SizedBox(width: 4),
//                 pw.Text(
//                   formattedDate,
//                   style: const pw.TextStyle(
//                       // font: font,
//                       fontSize: 12,
//                       color: PdfColors.black),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Future<pw.Widget> _buildDeviceCardpw(Map<String, dynamic> device, Uint8List info,
//     Uint8List condition, Uint8List time, Uint8List status, Uint8List calendar, pw.Font font) async {
//   final lastUpdated = device['lastUpdated']?.toDate();
//   final formattedDate = lastUpdated != null
//       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
//       : 'Unknown';

//   PdfColor cardColor = PdfColors.red;

//   final String deviceModel = device['model'] ?? 'Unknown Model';
//   final String deviceSN = device['sn'] ?? '';
//   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
//   final String deviceStatus = device['status'] ?? 'Unknown Status';
//   final String deviceRemarks = device['remark'] ?? '';

//   final String statusLabel;
//   final PdfColor statusColor;

//   if (notOccupiedStatuses.contains(deviceStatus)) {
//     statusLabel = 'Not Occupied @$deviceStatus';
//     statusColor = PdfColors.green;
//     cardColor = PdfColors.green;
//   } else if (serviceVendor.contains(deviceStatus)) {
//     statusLabel = 'Service @$deviceStatus';
//     statusColor = PdfColors.blue;
//     cardColor = PdfColors.blue;
//   } else {
//     statusLabel = 'Occupied @$deviceStatus';
//     statusColor = PdfColors.red;
//   }

//   return pw.Container(
//     margin: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//     padding: const pw.EdgeInsets.all(8),
//     decoration: pw.BoxDecoration(
//       borderRadius: pw.BorderRadius.circular(20),
//       gradient: pw.LinearGradient(
//         colors: [
//           PdfColors.white,
//           cardColor,
//         ],
//         begin: pw.Alignment.topLeft,
//         end: pw.Alignment.bottomRight,
//       ),
//     ),
//     child: pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         // Header
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//           children: [
//             pw.Expanded(
//               child: pw.Text(deviceModel,
//                   style: pw.TextStyle(
//                       font: font,
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold)),
//             ),
//             pw.Container(
//               padding: const pw.EdgeInsets.all(4),
//               decoration: pw.BoxDecoration(
//                 color: statusColor,
//                 borderRadius: pw.BorderRadius.circular(8),
//                 border: pw.Border.all(
//                   color: PdfColors.white,
//                   width: 1,
//                 ),
//               ),
//               child: pw.Text(
//                 deviceStatus,
//                 style: pw.TextStyle(
//                   font: font,
//                   color: PdfColors.white,
//                   fontSize: 12,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 8),
//         // Image & Details
//         pw.Row(
//           children: [
//             // Device Image
//             device['image'] != null && device['image']!.isNotEmpty
//                 ? pw.Image(
//                     pw.MemoryImage(base64Decode(device['image'])),
//                     width: 120,
//                     height: 80,
//                     fit: pw.BoxFit.fitWidth,
//                   )
//                 : pw.Container(
//                     width: 120,
//                     height: 80,
//                     decoration:
//                         const pw.BoxDecoration(color: PdfColors.grey300),
//                     child: pw.Center(child: pw.Text("No Image")),
//                   ),
//             pw.SizedBox(width: 16),
//             // Device Info
//             pw.Expanded(
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'SN: $deviceSN',
//                     style: pw.TextStyle(
//                         font: font, fontSize: 12, color: PdfColors.black),
//                   ),
//                   pw.SizedBox(height: 4),
//                   pw.Text(
//                     'Condition: $deviceCondition',
//                     style: pw.TextStyle(
//                         font: font, fontSize: 12, color: PdfColors.black),
//                   ),
//                   pw.SizedBox(height: 4),
//                   pw.Text(
//                     'Remarks: $deviceRemarks',
//                     style: pw.TextStyle(
//                         font: font, fontSize: 12, color: PdfColors.black),
//                     maxLines: 2,
//                     // overflow: pw.TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 16),
//         // Footer
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Row(
//               children: [
//                 pw.Text(
//                   'Last Updated: ',
//                   style: pw.TextStyle(
//                       font: font, fontSize: 12, color: PdfColors.black),
//                 ),
//                 pw.SizedBox(width: 4),
//                 pw.Text(
//                   formattedDate,
//                   style: pw.TextStyle(
//                       font: font, fontSize: 12, color: PdfColors.black),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// import 'dart:async';
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:projector_management/utility/fetchsetting.dart';

// Future<pw.Font> loadFont(String path) async {
//   final fontData = await rootBundle.load(path);
//   return pw.Font.ttf(fontData);
// }

//

// Future<Uint8List> generatePdfandShareSupportWeb(String device) async {
//   final pdf = pw.Document();
//   final font = await loadFont('fonts/Roboto-Regular.ttf');
//   final fontbold = await loadFont('fonts/Roboto-Bold.ttf');

//   final Uint8List info =
//       (await rootBundle.load('assets/png/info.png')).buffer.asUint8List();
//   final Uint8List store =
//       (await rootBundle.load('assets/png/store.png')).buffer.asUint8List();
//   final Uint8List hotel =
//       (await rootBundle.load('assets/png/hotel.png')).buffer.asUint8List();
//   final Uint8List service =
//       (await rootBundle.load('assets/png/screwdriver_wrench.png'))
//           .buffer
//           .asUint8List();
//   final Uint8List time =
//       (await rootBundle.load('assets/png/stopwatch.png')).buffer.asUint8List();
//   final Uint8List condition =
//       (await rootBundle.load('assets/png/wave_square.png'))
//           .buffer
//           .asUint8List();
//   final Uint8List calendar =
//       (await rootBundle.load('assets/png/calendar.png')).buffer.asUint8List();

//   // Fetch data from Firestore
//   final querySnapshot =
//       await FirebaseFirestore.instance.collection(device).get();
//   final devices = querySnapshot.docs.map((doc) {
//     final data = doc.data();
//     return {
//       'id': doc.id,
//       ...data,
//     };
//   }).toList();

//   await fetchSettings();

//   // Example statuses
//   final occupieddevices = devices
//       .where((device) =>
//           !notOccupiedStatuses.contains(device['status']) &&
//           !serviceVendor.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   final notOccupieddevices = devices
//       .where((device) => notOccupiedStatuses.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   final servicedevices = devices
//       .where((device) => serviceVendor.contains(device['status']))
//       .toList()
//     ..sort((a, b) => a['status'].compareTo(b['status']));

//   // Build device cards asynchronously
//   final occupiedDeviceCards = await _buildAllDeviceCards(
//       occupieddevices, info, condition, time, hotel, calendar, font);
//   final notOccupiedDeviceCards = await _buildAllDeviceCards(
//       notOccupieddevices, info, condition, time, store, calendar, font);
//   final serviceDeviceCards = await _buildAllDeviceCards(
//       servicedevices, info, condition, time, service, calendar, font);

//   // Add data to PDF
//   if ((occupieddevices.isNotEmpty) ||
//       (notOccupieddevices.isNotEmpty) ||
//       (servicedevices.isNotEmpty)) {
//     pdf.addPage(
//       pw.Page(
//         pageFormat: const PdfPageFormat(400, double.infinity, marginAll: 8.0),
//         build: (pw.Context context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Occupied $device',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.red,
//                 font: fontbold,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...occupiedDeviceCards,
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'Not Occupied $device',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.green,
//                 font: fontbold,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...notOccupiedDeviceCards,
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'On Service',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.blue,
//                 font: fontbold,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             ...serviceDeviceCards,
//           ],
//         ),
//       ),
//     );
//   }

//   final pdfBytes = await pdf.save();

//   return pdfBytes;
// }

// Future<pw.Widget> _buildDeviceCardpw(
//     Map<String, dynamic> device,
//     Uint8List info,
//     Uint8List condition,
//     Uint8List time,
//     Uint8List status,
//     Uint8List calendar,
//     pw.Font fontbold) async {
//   final lastUpdated = device['lastUpdated']?.toDate();
//   final formattedDate = lastUpdated != null
//       ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
//       : 'Unknown';

//   PdfColor cardColor = PdfColors.red;

//   final String deviceModel = device['model'] ?? 'Unknown Model';
//   final String deviceSN = device['sn'] ?? '';
//   final String deviceCondition = device['condition'] ?? 'Unknown Condition';
//   final String deviceStatus = device['status'] ?? 'Unknown Status';
//   final String deviceRemarks = device['remark'] ?? '';

//   final String statusLabel;
//   final PdfColor statusColor;

//   if (notOccupiedStatuses.contains(deviceStatus)) {
//     statusLabel = 'Not Occupied @$deviceStatus';
//     statusColor = PdfColors.green;
//     cardColor = PdfColors.green;
//   } else if (serviceVendor.contains(deviceStatus)) {
//     statusLabel = 'Service @$deviceStatus';
//     statusColor = PdfColors.blue;
//     cardColor = PdfColors.blue;
//   } else {
//     statusLabel = 'Occupied @$deviceStatus';
//     statusColor = PdfColors.red;
//   }

//   return pw.Container(
//     margin: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//     padding: const pw.EdgeInsets.all(8),
//     decoration: pw.BoxDecoration(
//       borderRadius: pw.BorderRadius.circular(20),
//       gradient: pw.LinearGradient(
//         colors: [
//           PdfColors.white,
//           cardColor,
//         ],
//         begin: pw.Alignment.topLeft,
//         end: pw.Alignment.bottomRight,
//       ),
//     ),
//     child: pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         // Header
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//           children: [
//             pw.Expanded(
//               child: pw.Text(deviceModel,
//                   style: pw.TextStyle(
//                       // font: fontbold,
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold)),
//             ),
//             pw.Container(
//               padding: const pw.EdgeInsets.all(4),
//               decoration: pw.BoxDecoration(
//                 color: statusColor,
//                 borderRadius: pw.BorderRadius.circular(8),
//                 border: pw.Border.all(
//                   color: PdfColors.white,
//                   width: 1,
//                 ),
//               ),
//               child: pw.Text(
//                 deviceStatus,
//                 style: pw.TextStyle(
//                   // font: fontbold,
//                   color: PdfColors.white,
//                   fontSize: 12,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 8),
//         // Image & Details
//         pw.Row(
//           children: [
//             // Device Image
//             device['image'] != null && device['image']!.isNotEmpty
//                 ? pw.Image(
//                     pw.MemoryImage(base64Decode(device['image'])),
//                     width: 120,
//                     height: 80,
//                     fit: pw.BoxFit.fitWidth,
//                   )
//                 : pw.Container(
//                     width: 120,
//                     height: 80,
//                     decoration:
//                         const pw.BoxDecoration(color: PdfColors.grey300),
//                     child: pw.Center(child: pw.Text("No Image")),
//                   ),
//             pw.SizedBox(width: 16),
//             // Device Info
//             pw.Expanded(
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'SN: $deviceSN',
//                     style: pw.TextStyle(
//                         font: fontbold, fontSize: 12, color: PdfColors.black),
//                   ),
//                   pw.SizedBox(height: 4),
//                   pw.Text(
//                     'Condition: $deviceCondition',
//                     style: pw.TextStyle(
//                         font: fontbold, fontSize: 12, color: PdfColors.black),
//                   ),
//                   pw.SizedBox(height: 4),
//                   pw.Text(
//                     'Remarks: $deviceRemarks',
//                     style: pw.TextStyle(
//                         font: fontbold, fontSize: 12, color: PdfColors.black),
//                     maxLines: 2,
//                     // overflow: pw.TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 16),
//         // Footer
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Row(
//               children: [
//                 pw.Text(
//                   'Last Updated: ',
//                   style: pw.TextStyle(
//                       font: fontbold, fontSize: 12, color: PdfColors.black),
//                 ),
//                 pw.SizedBox(width: 4),
//                 pw.Text(
//                   formattedDate,
//                   style: pw.TextStyle(
//                       font: fontbold, fontSize: 12, color: PdfColors.black),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projector_management/utility/fetchsetting.dart';

Future<pw.Font> loadFont(String path) async {
  final fontData = await rootBundle.load(path);
  return pw.Font.ttf(fontData);
}

Future<List<pw.Widget>> _buildAllDeviceCards(
    List<Map<String, dynamic>> devices,
    Uint8List info,
    Uint8List condition,
    Uint8List time,
    Uint8List status,
    Uint8List calendar,
    pw.Font fontbold) async {
  List<pw.Widget> deviceCards = [];
  for (var device in devices) {
    final card = await _buildDeviceCardpw(
        device, info, condition, time, status, calendar, fontbold);
    deviceCards.add(card);
  }
  return deviceCards;
}

Future<pw.Widget> _buildDeviceCardpw(
    Map<String, dynamic> device,
    Uint8List info,
    Uint8List condition,
    Uint8List time,
    Uint8List status,
    Uint8List calendar,
    pw.Font font) async {
  final lastUpdated = device['lastUpdated']?.toDate();
  final formattedDate = lastUpdated != null
      ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
      : 'Unknown';

  PdfColor cardColor = PdfColors.red;

  final String deviceModel = device['model'] ?? 'Unknown Model';
  final String deviceSN = device['sn'] ?? '';
  final String deviceCondition = device['condition'] ?? 'Unknown Condition';
  final String deviceStatus = device['status'] ?? 'Unknown Status';
  final String deviceRemarks = device['remark'] ?? '';

  final String statusLabel;
  final PdfColor statusColor;

  if (notOccupiedStatuses.contains(deviceStatus)) {
    statusLabel = 'Not Occupied @$deviceStatus';
    statusColor = PdfColors.green;
    cardColor = PdfColors.green;
  } else if (serviceVendor.contains(deviceStatus)) {
    statusLabel = 'Service @$deviceStatus';
    statusColor = PdfColors.blue;
    cardColor = PdfColors.blue;
  } else {
    statusLabel = 'Occupied @$deviceStatus';
    statusColor = PdfColors.red;
  }

  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      borderRadius: pw.BorderRadius.circular(20),
      gradient: pw.LinearGradient(
        colors: [
          PdfColors.white,
          cardColor,
        ],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Expanded(
              child: pw.Text(deviceModel,
                  style: pw.TextStyle(
                      font: font,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(4),
              decoration: pw.BoxDecoration(
                color: statusColor,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(
                  color: PdfColors.white,
                  width: 1,
                ),
              ),
              child: pw.Text(
                deviceStatus,
                style: pw.TextStyle(
                  font: font,
                  color: PdfColors.white,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        // Image & Details
        pw.Row(
          children: [
            // Device Image
            device['image'] != null && device['image']!.isNotEmpty
                ? pw.Image(
                    pw.MemoryImage(base64Decode(device['image'])),
                    width: 120,
                    height: 80,
                    fit: pw.BoxFit.fitWidth,
                  )
                : pw.Container(
                    width: 120,
                    height: 80,
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    child: pw.Center(child: pw.Text("No Image")),
                  ),
            pw.SizedBox(width: 16),
            // Device Info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SN: $deviceSN',
                    style: pw.TextStyle(
                        font: font, fontSize: 12, color: PdfColors.black),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Condition: $deviceCondition',
                    style: pw.TextStyle(
                        font: font, fontSize: 12, color: PdfColors.black),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Remarks: $deviceRemarks',
                    style: pw.TextStyle(
                        font: font, fontSize: 12, color: PdfColors.black),
                    maxLines: 2,
                    // overflow: pw.TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        // Footer
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pw.Text(
                  'Last Updated: ',
                  style: pw.TextStyle(
                      font: font, fontSize: 12, color: PdfColors.black),
                ),
                pw.SizedBox(width: 4),
                pw.Text(
                  formattedDate,
                  style: pw.TextStyle(
                      font: font, fontSize: 12, color: PdfColors.black),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Future<Uint8List> generatePdfandShareSupportWeb(String device) async {
  final pdf = pw.Document();
  final regularFont = await loadFont('assets/fonts/Roboto-Regular.ttf');
  final boldFont = await loadFont('assets/fonts/Roboto-Bold.ttf');

  final Uint8List info =
      (await rootBundle.load('assets/png/info.png')).buffer.asUint8List();
  final Uint8List store =
      (await rootBundle.load('assets/png/store.png')).buffer.asUint8List();
  final Uint8List hotel =
      (await rootBundle.load('assets/png/hotel.png')).buffer.asUint8List();
  final Uint8List service =
      (await rootBundle.load('assets/png/screwdriver_wrench.png'))
          .buffer
          .asUint8List();
  final Uint8List time =
      (await rootBundle.load('assets/png/stopwatch.png')).buffer.asUint8List();
  final Uint8List condition =
      (await rootBundle.load('assets/png/wave_square.png'))
          .buffer
          .asUint8List();
  final Uint8List calendar =
      (await rootBundle.load('assets/png/calendar.png')).buffer.asUint8List();

  // Fetch data from Firestore
  final querySnapshot =
      await FirebaseFirestore.instance.collection(device).get();
  final devices = querySnapshot.docs.map((doc) {
    final data = doc.data();
    return {
      'id': doc.id,
      ...data,
    };
  }).toList();

  await fetchSettings();

  // Example statuses
  final occupieddevices = devices
      .where((device) =>
          !notOccupiedStatuses.contains(device['status']) &&
          !serviceVendor.contains(device['status']))
      .toList()
    ..sort((a, b) => a['status'].compareTo(b['status']));

  final notOccupieddevices = devices
      .where((device) => notOccupiedStatuses.contains(device['status']))
      .toList()
    ..sort((a, b) => a['status'].compareTo(b['status']));

  final servicedevices = devices
      .where((device) => serviceVendor.contains(device['status']))
      .toList()
    ..sort((a, b) => a['status'].compareTo(b['status']));

  // Build device cards asynchronously
  final occupiedDeviceCards = await _buildAllDeviceCards(
      occupieddevices, info, condition, time, hotel, calendar, regularFont);
  final notOccupiedDeviceCards = await _buildAllDeviceCards(
      notOccupieddevices, info, condition, time, store, calendar, regularFont);
  final serviceDeviceCards = await _buildAllDeviceCards(
      servicedevices, info, condition, time, service, calendar, regularFont);

  // Add data to PDF
  if ((occupieddevices.isNotEmpty) ||
      (notOccupieddevices.isNotEmpty) ||
      (servicedevices.isNotEmpty)) {
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(400, double.infinity, marginAll: 8.0),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Occupied $device',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.red,
                font: boldFont,
              ),
            ),
            pw.SizedBox(height: 5),
            ...occupiedDeviceCards,
            pw.SizedBox(height: 5),
            pw.Text(
              'Not Occupied $device',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
                font: boldFont,
              ),
            ),
            pw.SizedBox(height: 5),
            ...notOccupiedDeviceCards,
            pw.SizedBox(height: 5),
            pw.Text(
              'On Service',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
                font: boldFont,
              ),
            ),
            pw.SizedBox(height: 5),
            ...serviceDeviceCards,
          ],
        ),
      ),
    );
  }

  final pdfBytes = await pdf.save();

  return pdfBytes;
}
