import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Map<String, Map<String, List<String>>> categorizedDevices = {
  "Projector": {
    "Room": [],
    "Pantry/Panel": [],
    "Store": [],
    "Service Vendor": [],
  },
  "Screen": {
    "Room": [],
    "Pantry/Panel": [],
    "Store": [],
    "Service Vendor": [],
  },
  "Sound": {
    "Room": [],
    "Pantry/Panel": [],
    "Store": [],
    "Service Vendor": [],
  },
};

Future<Uint8List> generatePdfandShareSupportWeb(String deviceType) async {
  final pdf = pw.Document();

  // Fetch data from Firestore
  final querySnapshot = await FirebaseFirestore.instance
      .collection('${deviceType.toLowerCase()}s')
      .get();
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
        .doc('${deviceType.toLowerCase()}_config')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      categorizedDevices[deviceType] = data.map((key, value) =>
          MapEntry(key, List<String>.from(value as List<dynamic>)));
    }
  } catch (e) {
    log('Error fetching settings for $deviceType: $e');
  }

  final notOccupiedStatuses =
      List<String>.from(categorizedDevices[deviceType]?["Pantry/Panel"] ?? []) +
          List<String>.from(categorizedDevices[deviceType]?["Store"] ?? []);

  final serviceVendorStatuses = List<String>.from(
      categorizedDevices[deviceType]?["Service Vendor"] ?? []);

  final occupiedDevices = devices
      .where((device) =>
          !notOccupiedStatuses.contains(device['status'] as String) &&
          !serviceVendorStatuses.contains(device['status'] as String))
      .toList();

  final notOccupiedDevices = devices
      .where(
          (device) => notOccupiedStatuses.contains(device['status'] as String))
      .toList();

  final serviceDevices = devices
      .where((device) =>
          serviceVendorStatuses.contains(device['status'] as String))
      .toList();

  pdf.addPage(
    pw.Page(
      pageFormat: const PdfPageFormat(400, double.infinity, marginAll: 8.0),
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Occupied $deviceType',
            occupiedDevices.map((e) => Map<String, String>.from(e)).toList(),
            List<String>.from(notOccupiedStatuses),
            List<String>.from(serviceVendorStatuses),
          ),
          _buildSection(
            'Not Occupied $deviceType',
            notOccupiedDevices.map((e) => Map<String, String>.from(e)).toList(),
            List<String>.from(notOccupiedStatuses),
            List<String>.from(serviceVendorStatuses),
          ),
          _buildSection(
            'On Service',
            serviceDevices.map((e) => Map<String, String>.from(e)).toList(),
            List<String>.from(notOccupiedStatuses),
            List<String>.from(serviceVendorStatuses),
          ),
        ],
      ),
    ),
  );

  final pdfBytes = await pdf.save();
  return pdfBytes;
}

pw.Widget _buildSection(
  String title,
  List<Map<String, String>> devices,
  List<String> notOccupiedStatuses,
  List<String> serviceVendorStatuses,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          color: title.contains('Occupied')
              ? PdfColors.red
              : title.contains('Not Occupied')
                  ? PdfColors.green
                  : PdfColors.blue,
        ),
      ),
      pw.SizedBox(height: 5),
      ...devices.map((device) {
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 5),
          child: _buildDeviceCardpw(
              device, notOccupiedStatuses, serviceVendorStatuses),
        );
      }).toList(),
    ],
  );
}

pw.Widget _buildDeviceCardpw(Map<String, dynamic> device,
    List<String> notOccupiedStatuses, List<String> serviceVendorStatuses) {
  final lastUpdated = device['lastUpdated']?.toDate();
  final formattedDate = lastUpdated != null
      ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
      : 'Unknown';

  PdfColor cardColor = PdfColors.grey100;

  final String deviceStatus = device['status'];
  final String statusLabel;
  final PdfColor statusColor;

  if (notOccupiedStatuses.contains(deviceStatus)) {
    statusLabel = 'Not Occupied @$deviceStatus';
    statusColor = PdfColors.green;
    cardColor = PdfColors.green100;
  } else if (serviceVendorStatuses.contains(deviceStatus)) {
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
              pw.Text(
                'Last Updated: $formattedDate',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
              pw.Text('Status: ${device['status']}'),
            ],
          ),
        ),
      ],
    ),
  );
}
