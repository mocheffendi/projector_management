import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ProjectorApp());

class ProjectorApp extends StatelessWidget {
  const ProjectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto', // Set the default font family
      ),
      home: const ProjectorHomePage(),
    );
  }
}

class ProjectorHomePage extends StatefulWidget {
  const ProjectorHomePage({super.key});

  @override
  State<ProjectorHomePage> createState() => _ProjectorHomePageState();
}

class _ProjectorHomePageState extends State<ProjectorHomePage> {
  List<Map<String, dynamic>> projectors = [
    {
      'model': 'EPSON EB-X51',
      'sn': 'X8A43202321',
      'status': 'not use',
      'image': 'assets/epson_x51.png'
    },
    {
      'model': 'EPSON EB-X51',
      'sn': 'X8A43201960',
      'status': 'not use',
      'image': 'assets/epson_x51.png'
    },
    {
      'model': 'EPSON EB-1776w',
      'sn': 'RESK6900139',
      'status': 'not use',
      'image': 'assets/epson_1776w.png'
    },
    {
      'model': 'EPSON EB-1776w',
      'sn': 'RESK6900168',
      'status': 'not use',
      'image': 'assets/epson_1776w.png'
    },
    {
      'model': 'EPSON EB-2155w',
      'sn': 'X3M5740048L',
      'status': 'not use',
      'image': 'assets/epson_2155w.png'
    },
    {
      'model': 'PANASONIC PT-EX800',
      'sn': 'DD9240004',
      'status': 'Ballroom A',
      'image': 'assets/panasonic_ex800.png',
      'occupied': true
    },
    {
      'model': 'SONY VPL-CH370',
      'sn': '7008744 848s',
      'status': 'Grand Ballroom',
      'image': 'assets/sony_ch370.png',
      'occupied': true
    },
  ];

  final List<String> roomOptions = [
    'not use',
    'Grand Ballroom',
    'Ballroom A',
    'Ballroom B',
    'VIP Ballroom',
    'Plataran',
    'Grand Destination',
    'Main Destination',
    'West Destination',
    'East Destination',
    'Una Una GD',
    'Una Una Exec Lounge',
    'Atmosphere',
    'Grand Argon',
    'Argon I',
    'Argon II',
    'Oxygen',
    'Hydrogen',
    'Nitrogen',
    'Helium',
    'Crypton',
    'Neon',
    'Xenon',
    'Food Exchange',
    'The Heritage'
  ];

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  Future<void> _loadStatuses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < projectors.length; i++) {
        String savedStatus =
            prefs.getString('projector_status_$i') ?? 'not use';
        projectors[i]['status'] = savedStatus;
        projectors[i]['occupied'] = savedStatus != 'not use';
      }
    });
  }

  Future<void> _saveStatus(int index, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('projector_status_$index', status);
  }

  void updateStatus(int index, String newStatus) {
    setState(() {
      projectors[index]['status'] = newStatus;
      projectors[index]['occupied'] = newStatus != 'not use';
    });
    _saveStatus(index, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Projector Management | Novotel Samator',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: projectors.length,
        itemBuilder: (context, index) {
          final projector = projectors[index];
          Color cardColor = projector['status'] == 'not use'
              ? Colors.green.shade100
              : Colors.white;

          return Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Projector Image
                  Image.asset(
                    projector['image'],
                    width: 150,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  // Projector Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${projector['model']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text('SN: ${projector['sn']}'),
                        if (projector['occupied'] == true)
                          Text(
                            'Occupied @${projector['status']}, ${DateTime.now()}',
                            style: const TextStyle(color: Colors.red),
                          )
                        else
                          const Text(
                            'not Occupied / @AV_Warehouse',
                            style: TextStyle(color: Colors.green),
                          ),
                        DropdownButton<String>(
                          value: projector['status'],
                          onChanged: (newValue) {
                            if (newValue != null) {
                              updateStatus(index, newValue);
                            }
                          },
                          items: roomOptions.map((room) {
                            return DropdownMenuItem<String>(
                              value: room,
                              child: Text(room),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Dropdown Menu for Room Selection
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
