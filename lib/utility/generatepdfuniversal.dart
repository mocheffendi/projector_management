import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Map<String, List<String>> categorizedOptions = {
  "Room": [],
  "Pantry/Panel": [],
  "Store": [],
  "Service Vendor": [],
};

List<String> roomOptions = [];
List<String> pantryPanel = [];
List<String> store = [];
List<String> notOccupiedStatuses = [];
List<String> serviceVendor = [];

Future<Uint8List> generatePdfandShareSupportWeb(String device) async {
  final pdf = pw.Document();

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

  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('config2')
        .get();

    if (snapshot.exists) {
      // setState(() {
      final data = snapshot.data() as Map<String, dynamic>;
      categorizedOptions = data.map((key, value) =>
          MapEntry(key, List<String>.from(value as List<dynamic>)));
      // });
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

  // Add data to PDF
  if (occupieddevices.isNotEmpty) {
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
              ),
            ),
            pw.SizedBox(height: 5),
            ...occupieddevices.map((device) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _builddeviceCardpw(device),
              );
            }).toList(),
            pw.SizedBox(height: 5),
            pw.Text(
              'Not Occupied $device',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.SizedBox(height: 5),
            ...notOccupieddevices.map((device) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _builddeviceCardpw(device),
              );
            }).toList(),
            pw.SizedBox(height: 5),
            pw.Text(
              'On Service',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.SizedBox(height: 5),
            ...servicedevices.map((device) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _builddeviceCardpw(device),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  final pdfBytes = await pdf.save();

  return pdfBytes;
}

pw.Widget _builddeviceCardpw(Map<String, dynamic> device) {
  final lastUpdated = device['lastUpdated']?.toDate();
  final formattedDate = lastUpdated != null
      ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
      : 'Unknown';

  PdfColor cardColor = PdfColors.grey100;

  // Example device status
  final String deviceStatus = device['status'];
  final String statusLabel;
  final PdfColor statusColor;

  if (notOccupiedStatuses.contains(deviceStatus)) {
    statusLabel = 'Not Occupied @$deviceStatus';
    statusColor = PdfColors.green;
    cardColor = PdfColors.green100;
  } else if (serviceVendor.contains(deviceStatus)) {
    statusLabel = 'Service @$deviceStatus';
    statusColor = PdfColors.blue;
    cardColor = PdfColors.blue100;
  } else {
    statusLabel = 'Occupied @$deviceStatus';
    statusColor = PdfColors.red;
  }

  return pw.Container(
    decoration: pw.BoxDecoration(
        color: cardColor, borderRadius: pw.BorderRadius.circular(8)),
    margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
    padding: const pw.EdgeInsets.all(5.0),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        device['image'] != null
            ? pw.Image(
                pw.MemoryImage(base64Decode(device['image'] ?? '')),
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
                '${device['model']}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('SN: ${device['sn']}'),
              pw.Text(
                statusLabel,
                style: pw.TextStyle(
                  color: statusColor,
                ),
              ),
              pw.Row(children: [
                // pw.Image(iconImage, width: 100, height: 100),
                pw.Text(
                  'Last Updated: $formattedDate',
                  style:
                      const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
              ]),
              // Dropdowns and popup menus are not supported in PDF widgets.
              // Replace with static information or remove them.
              pw.Text('Status: ${device['status']}'),
            ],
          ),
        ),
      ],
    ),
  );
}
