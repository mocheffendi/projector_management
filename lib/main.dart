// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:projector_management/screen/devicepage.dart';
// import 'package:projector_management/screen/settingpage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//       options: const FirebaseOptions(
//     apiKey: 'AIzaSyBSor1UaXN1VY9g1GeCa3bXVmMI7fFOzE0',
//     appId: '1:898353156158:web:c4b924a8c5abaab5d3416f',
//     messagingSenderId: '898353156158',
//     projectId: 'myflutter-49607',
//     storageBucket: 'myflutter-49607.firebasestorage.app',
//   ));

//   runApp(const ProjectorApp());
// }

// class ProjectorApp extends StatelessWidget {
//   const ProjectorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MainAppScreen(),
//     );
//   }
// }

// class MainAppScreen extends StatefulWidget {
//   const MainAppScreen({super.key});

//   @override
//   State<MainAppScreen> createState() => _MainAppScreenState();
// }

// class _MainAppScreenState extends State<MainAppScreen> {
//   // Define the same color for both AppBar and Status Bar
//   static const Color appBarColor = Colors.blue;

//   int _currentIndex = 0;

//   // Define the screens for each tab
//   final List<Widget> _screens = [
//     const DevicePage(collectionName: 'projectors'),
//     const DevicePage(collectionName: 'screens'),
//     const DevicePage(collectionName: 'sounds'),
//     const DevicePage(collectionName: 'avdevices'),
//     const SettingsPage()
//   ];

//   // Define titles for each tab
//   final List<String> _titles = [
//     'Projector Management | Novotel Samator',
//     'Screen Management | Novotel Samator',
//     'Sound Management | Novotel Samator',
//     'AV Device Management | Novotel Samator',
//     'Settings | Novotel Samator',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           systemNavigationBarColor: appBarColor, // navigation bar color
//           systemNavigationBarDividerColor: appBarColor,
//           statusBarColor: appBarColor, // status bar color
//           systemNavigationBarIconBrightness: Brightness.light,
//           statusBarBrightness: Brightness.light,
//           statusBarIconBrightness: Brightness.light,
//         ),
//         backgroundColor: appBarColor, // AppBar color
//         title: Text(
//           _titles[_currentIndex],
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: _screens[_currentIndex],
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _currentIndex,
//         onDestinationSelected: (int index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.location_searching_rounded),
//             label: 'Projector',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.video_label),
//             label: 'Screen',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.speaker),
//             label: 'Sound',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.devices_other),
//             label: 'AV Device',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:projector_management/screen/devicepage.dart';
import 'package:projector_management/screen/settingpage.dart';

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
  static const Color appBarColor = Colors.blue;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DevicePage(collectionName: 'projectors'),
    const DevicePage(collectionName: 'screens'),
    const DevicePage(collectionName: 'sounds'),
    const DevicePage(collectionName: 'avdevices'),
    const SettingsPage()
  ];

  final List<String> _titles = [
    'Projector Management | Novotel Samator',
    'Screen Management | Novotel Samator',
    'Sound Management | Novotel Samator',
    'AV Device Management | Novotel Samator',
    'Settings | Novotel Samator',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 500) {
          // Tampilan untuk layar kecil (Mobile)
          return _buildMobileLayout();
        } else {
          // Tampilan untuk layar besar (Desktop)
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: appBarColor,
          systemNavigationBarDividerColor: appBarColor,
          statusBarColor: appBarColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: appBarColor,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.location_searching_rounded),
            label: 'Projector',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_label),
            label: 'Screen',
          ),
          NavigationDestination(
            icon: Icon(Icons.speaker),
            label: 'Sound',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_other),
            label: 'AV Device',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            labelType: labelType,
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.location_searching_rounded),
                label: Text('Projector'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.video_label),
                label: Text('Screen'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.speaker),
                label: Text('Sound'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.devices_other),
                label: Text('AV Device'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
    );
  }
}
