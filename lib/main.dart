// import 'dart:convert'; // To handle image encoding as base64
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projector_management/settingpage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
import 'projectorview.dart';
import 'screenview.dart';
import 'soundview.dart';
import 'avdeviceview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBSor1UaXN1VY9g1GeCa3bXVmMI7fFOzE0',
    appId: '1:898353156158:web:c4b924a8c5abaab5d3416f',
    messagingSenderId: '898353156158',
    projectId: 'myflutter-49607',
    storageBucket: 'myflutter-49607.firebasestorage.app',
  ));

  runApp(const ProjectorApp());
}

class ProjectorApp extends StatelessWidget {
  const ProjectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainAppScreen(),
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  // Define the screens for each tab
  final List<Widget> _screens = [
    const ProjectorPage(),
    const ScreenPage(),
    const SoundPage(),
    const AVDevicePage(),
    const SettingsPage()
  ];

  // Define titles for each tab
  final List<String> _titles = [
    'Projector Management | Novotel Samator',
    'Screen Management | Novotel Samator',
    'Sound Management | Novotel Samator',
    'AV Device Management | Novotel Samator',
    'Settings | Novotel Samator',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Added this line
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            label: 'Projector',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.screen_share),
            label: 'Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker),
            label: 'Sound',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices_other),
            label: 'AV Device',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
