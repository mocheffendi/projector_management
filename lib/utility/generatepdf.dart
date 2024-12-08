import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
// import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:projector_management/utility/pdftoimage.dart';

List<String> roomOptions = [];
List<String> notOccupiedStatuses = [];
List<String> serviceOptions = [];

Future<Uint8List> generatePdfandShareSupportWeb() async {
  final pdf = pw.Document();

  // Fetch data from Firestore
  final querySnapshot =
      await FirebaseFirestore.instance.collection('projectors').get();
  final projectors = querySnapshot.docs.map((doc) {
    final data = doc.data();
    return {
      'id': doc.id,
      ...data,
    };
  }).toList();

  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('config')
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      // setState(() {
      roomOptions = List<String>.from(data['roomOptions']);
      notOccupiedStatuses = List<String>.from(data['notOccupiedStatuses']);
      serviceOptions = List<String>.from(data['serviceOptions']);
      // });
    }
  } catch (e) {
    log('Error fetching settings: $e');
  }

  // Example statuses
  final occupiedProjectors = projectors
      .where((projector) =>
          !notOccupiedStatuses.contains(projector['status']) &&
          !serviceOptions.contains(projector['status']))
      .toList();

  final notOccupiedProjectors = projectors
      .where((projector) => notOccupiedStatuses.contains(projector['status']))
      .toList();

  final serviceProjectors = projectors
      .where((projector) => serviceOptions.contains(projector['status']))
      .toList();

  // Add data to PDF
  if (occupiedProjectors.isNotEmpty) {
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(400, double.infinity, marginAll: 8.0),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Occupied Projectors',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.red,
              ),
            ),
            pw.SizedBox(height: 5),
            ...occupiedProjectors.map((projector) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _buildProjectorCardpw(projector),
              );
            }).toList(),
            pw.SizedBox(height: 5),
            pw.Text(
              'Not Occupied Projectors',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.SizedBox(height: 5),
            ...notOccupiedProjectors.map((projector) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _buildProjectorCardpw(projector),
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
            ...serviceProjectors.map((projector) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _buildProjectorCardpw(projector),
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

pw.Widget _buildProjectorCardpw(Map<String, dynamic> projector) {
  final lastUpdated = projector['lastUpdated']?.toDate();
  final formattedDate = lastUpdated != null
      ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
      : 'Unknown';

  PdfColor cardColor = PdfColors.grey100;

  // Example projector status
  final String projectorStatus = projector['status'];
  final String statusLabel;
  final PdfColor statusColor;

  if (notOccupiedStatuses.contains(projectorStatus)) {
    statusLabel = 'Not Occupied @$projectorStatus';
    statusColor = PdfColors.green;
    cardColor = PdfColors.green100;
  } else if (serviceOptions.contains(projectorStatus)) {
    statusLabel = 'Service @$projectorStatus';
    statusColor = PdfColors.blue;
    cardColor = PdfColors.blue100;
  } else {
    statusLabel = 'Occupied @$projectorStatus';
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
        projector['image'] != null
            ? pw.Image(
                pw.MemoryImage(base64Decode(projector['image'] ?? '')),
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
                '${projector['model']}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('SN: ${projector['sn']}'),
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
              pw.Text('Status: ${projector['status']}'),
            ],
          ),
        ),
      ],
    ),
  );
}
