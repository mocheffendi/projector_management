import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projector_management/utility/pdftoimage.dart';

List<String> roomOptions = [];
List<String> notOccupiedStatuses = [];

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
      // });
    }
  } catch (e) {
    log('Error fetching settings: $e');
  }

  // Example statuses
  final occupiedProjectors = projectors
      .where((projector) => !notOccupiedStatuses.contains(projector['status']))
      .toList();
  final notOccupiedProjectors = projectors
      .where((projector) => notOccupiedStatuses.contains(projector['status']))
      .toList();

  // Add data to PDF
  if (occupiedProjectors.isNotEmpty) {
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(450, 1100, marginAll: 8.0),
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
          ],
        ),
      ),
    );
  }

  final pdfBytes = await pdf.save();

  // Verify if pdfBytes is correctly populated
  // if (pdfBytes.isEmpty) {
  //   debugPrint('PDF bytes are empty.');
  // } else {
  //   debugPrint('PDF bytes length: ${pdfBytes.length}');
  // }

  // debugPrint('PDF bytes length: ${pdfBytes.length}');
  // debugPrint('PNG bytes length: ${pngBytes.length}');

  return pdfBytes;
}

Future<Uint8List> generatePdfandShare() async {
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
      // });
    }
  } catch (e) {
    log('Error fetching settings: $e');
  }

  // Example statuses
  final occupiedProjectors = projectors
      .where((projector) => !notOccupiedStatuses.contains(projector['status']))
      .toList();
  final notOccupiedProjectors = projectors
      .where((projector) => notOccupiedStatuses.contains(projector['status']))
      .toList();

  // Add data to PDF
  if (occupiedProjectors.isNotEmpty) {
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(450, 1000, marginAll: 8.0),
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
          ],
        ),
      ),
    );
  }

  final bytes = await pdf.save();

  return bytes;
}

pw.Widget _buildProjectorCardpw(Map<String, dynamic> projector) {
  final lastUpdated = projector['lastUpdated']?.toDate();
  final formattedDate = lastUpdated != null
      ? DateFormat('dd-MM-yyyy HH:mm:ss').format(lastUpdated)
      : 'Unknown';

  // Determine card color based on status
  final cardColor = [
    'not use',
    'FO Office',
    'Store LT2',
    'Pantry / Panel Una²',
    'Pantry / Panel Lantai5',
    'Pantry / Panel Lantai3',
    'Pantry / Panel Heritage',
    'Office Eng'
  ].contains(projector['status'])
      ? PdfColors.green100
      : PdfColors.grey300;

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
                notOccupiedStatuses.contains(projector['status'])
                    ? 'Not Occupied @${projector['status']}'
                    : 'Occupied @${projector['status']}',
                style: pw.TextStyle(
                  color: notOccupiedStatuses.contains(projector['status'])
                      ? PdfColors.green
                      : PdfColors.red,
                ),
              ),
              pw.Text(
                'Last Updated: $formattedDate',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
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
