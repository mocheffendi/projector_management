import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:projector_management/screen/devicepage.dart';
import 'package:projector_management/screen/settingpage.dart';
import 'screen/projectorview.dart';
import 'screen/screenview.dart';
import 'screen/soundview.dart';
import 'screen/avdeviceview.dart';

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
  // Define the same color for both AppBar and Status Bar
  static const Color appBarColor = Colors.blue;

  int _currentIndex = 0;

  // Define the screens for each tab
  final List<Widget> _screens = [
    const DevicePage(collectionName: 'projectors'),
    const DevicePage(collectionName: 'screens'),
    const DevicePage(collectionName: 'sounds'),
    const DevicePage(collectionName: 'avdevices'),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: appBarColor, // navigation bar color
          systemNavigationBarDividerColor: appBarColor,
          statusBarColor: appBarColor, // status bar color
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: appBarColor, // AppBar color
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
            icon: Icon(Icons.location_searching_rounded),
            label: 'Projector',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
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
