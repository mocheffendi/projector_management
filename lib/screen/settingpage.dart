import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController roomController = TextEditingController();
  final TextEditingController notOccupiedController = TextEditingController();

  // Fetch the current values from Firestore (or from local storage)
  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config')
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          roomController.text = data['roomOptions'].join(', ');
          notOccupiedController.text = data['notOccupiedStatuses'].join(', ');
        });
      }
    } catch (e) {
      log('Error fetching settings: $e');
    }
  }

  // Save the edited values to Firestore
  Future<void> _saveSettings() async {
    try {
      List<String> updatedRoomOptions =
          roomController.text.split(',').map((e) => e.trim()).toList();
      List<String> updatedNotOccupied =
          notOccupiedController.text.split(',').map((e) => e.trim()).toList();

      await FirebaseFirestore.instance
          .collection('settings')
          .doc('config')
          .set({
        'roomOptions': updatedRoomOptions,
        'notOccupiedStatuses': updatedNotOccupied,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Settings saved successfully'),
        ));
      }
    } catch (e) {
      log('Error saving settings: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: roomController,
              decoration: const InputDecoration(
                  labelText: 'Room Options (comma separated)'),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notOccupiedController,
              decoration: const InputDecoration(
                  labelText: 'Not Occupied Statuses (comma separated)'),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
