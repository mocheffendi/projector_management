import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projector_management/utility/fetchsetting.dart';

Future<Uint8List> generatePdfandShareSupportWeb(String device) async {
  final pdf = pw.Document();

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
              ),
            ),
            pw.SizedBox(height: 5),
            ...occupieddevices.map((device) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: _builddeviceCardpw(
                    device, info, condition, time, hotel, calendar),
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
                child: _builddeviceCardpw(
                    device, info, condition, time, store, calendar),
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
                child: _builddeviceCardpw(
                    device, info, condition, time, service, calendar),
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

pw.Widget _builddeviceCardpw(Map<String, dynamic> device, Uint8List info,
    Uint8List condition, Uint8List time, Uint8List status, Uint8List calendar) {
  final lastUpdated = device['lastUpdated']?.toDate();
  final formattedDate = lastUpdated != null
      ? DateFormat('dd-MM-yyyy HH:mm').format(lastUpdated)
      : 'Unknown';

  PdfColor cardColor = PdfColors.grey100;

  final imageInfo = pw.MemoryImage(info); // Convert to MemoryImage
  final imageCondition = pw.MemoryImage(condition);
  final imageTime = pw.MemoryImage(time);
  final imageStatus = pw.MemoryImage(status);
  final imageCalendar = pw.MemoryImage(calendar);
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
              pw.Row(children: [
                pw.Image(
                  imageInfo,
                  width: 12,
                  height: 12,
                  fit: pw.BoxFit.contain,
                ),
                pw.Text('SN: ${device['sn']}'),
              ]),
              pw.Row(children: [
                pw.Image(
                  imageCondition,
                  width: 12,
                  height: 12,
                  fit: pw.BoxFit.contain,
                ),
                pw.Text('Condition: ${device['condition']}'),
              ]),
              pw.Row(children: [
                pw.Image(
                  imageTime,
                  width: 12,
                  height: 12,
                  fit: pw.BoxFit.contain,
                ),
                pw.Text('${device['remark']}'),
              ]),
              pw.Row(children: [
                pw.Image(
                  imageStatus,
                  width: 12,
                  height: 12,
                  fit: pw.BoxFit.contain,
                ),
                pw.Text(
                  statusLabel,
                  style: pw.TextStyle(
                    color: statusColor,
                  ),
                ),
              ]),
              pw.Row(children: [
                // pw.Image(iconImage, width: 100, height: 100),
                pw.Image(
                  imageCalendar,
                  width: 12,
                  height: 12,
                  fit: pw.BoxFit.contain,
                ),
                pw.Text(
                  'Last Updated: $formattedDate',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold),
                ),
              ]),
              pw.Row(children: [
                pw.Image(
                  imageStatus,
                  width: 12,
                  height: 12,
                  fit: pw.BoxFit.contain,
                ),
                pw.Text('Status: ${device['status']}'),
              ])
            ],
          ),
        ),
      ],
    ),
  );
}
