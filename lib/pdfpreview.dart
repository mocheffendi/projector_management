import 'dart:convert'; // To handle image encoding as base64
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({super.key});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  List<String> roomOptions = [];
  List<String> notOccupiedStatuses = [];

  Future<pw.Document> _generatePdfandShareSupportWeb() async {
    final pdf = pw.Document();

    // Fetch data from Firestore
    final querySnapshot =
        await FirebaseFirestore.instance.collection('projectors').get();
    final projectors = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
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
        setState(() {
          roomOptions = List<String>.from(data['roomOptions']);
          notOccupiedStatuses = List<String>.from(data['notOccupiedStatuses']);
        });
      }
    } catch (e) {
      log('Error fetching settings: $e');
    }

    // Example statuses
    final occupiedProjectors = projectors
        .where((projector) => notOccupiedStatuses.contains(projector['status']))
        .toList();
    final notOccupiedProjectors = projectors
        .where((projector) => notOccupiedStatuses.contains(projector['status']))
        .toList();

    // Add data to PDF
    if (occupiedProjectors.isNotEmpty) {
      pdf.addPage(
        pw.Page(
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
              pw.SizedBox(height: 10),
              ...occupiedProjectors.map((projector) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: _buildProjectorCardpw(projector),
                );
              }).toList(),
              pw.SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    if (notOccupiedProjectors.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Not Occupied Projectors',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                ),
              ),
              pw.SizedBox(height: 10),
              ...notOccupiedProjectors.map((projector) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: _buildProjectorCardpw(projector),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }

    return pdf;
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config')
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          roomOptions = List<String>.from(data['roomOptions']);
          notOccupiedStatuses = List<String>.from(data['notOccupiedStatuses']);
        });
      }
    } catch (e) {
      log('Error fetching settings: $e');
    }
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

  pw.Widget _buildProjectorCardpw(Map<String, dynamic> projector) {
    final lastUpdated = projector['lastUpdated']?.toDate();
    final formattedDate = lastUpdated != null
        ? DateFormat('dd-MM-yyyy HH:mm:ss').format(lastUpdated)
        : 'Unknown';

    // Determine card color based on status
    final cardColor = [
      'not use',
      'FO Office',
      'Warehouse LT2',
      'Pantry / Panel Una²',
      'Pantry / Panel Lantai5',
      'Pantry / Panel Lantai3',
      'Pantry / Panel Heritage'
    ].contains(projector['status'])
        ? PdfColors.green100
        : PdfColors.white;

    return pw.Container(
      color: cardColor,
      margin: const pw.EdgeInsets.symmetric(vertical: 6.0),
      padding: const pw.EdgeInsets.all(8.0),
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
          pw.SizedBox(width: 10),
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
                  !notOccupiedStatuses.contains(projector['status'])
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
                  style:
                      const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) async {
          final pdf = await _generatePdfandShareSupportWeb();
          return pdf.save();
        },
        canChangePageFormat: false, // Optional: Prevent changing page format
        pdfFileName: 'example.pdf', // Optional: Name of the file when saved
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          log('button Pressed');
          _generatePdfandShareSupportWeb();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
