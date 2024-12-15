// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:projector_management/main2.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   final TextEditingController roomController = TextEditingController();
//   final TextEditingController pantryPanelController = TextEditingController();
//   final TextEditingController notOccupiedController = TextEditingController();
//   final TextEditingController serviceController =
//       TextEditingController(); // New controller

//   // Fetch the current values from Firestore (or from local storage)
//   Future<void> _fetchSettings() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('settings')
//           .doc('config')
//           .get();

//       if (snapshot.exists) {
//         var data = snapshot.data() as Map<String, dynamic>;
//         setState(() {
//           roomController.text = data['roomOptions'].join(', ');
//           pantryPanelController.text = data['pantrypanelOptions'].join(', ');
//           notOccupiedController.text = data['notOccupiedStatuses'].join(', ');
//           serviceController.text =
//               data['serviceVendor'].join(', '); // Fetch Service data
//         });
//       }
//     } catch (e) {
//       log('Error fetching settings: $e');
//     }
//   }

//   // Save the edited values to Firestore
//   Future<void> _saveSettings() async {
//     try {
//       List<String> updatedRoomOptions =
//           roomController.text.split(',').map((e) => e.trim()).toList()..sort();
//       List<String> updatedPantryPanelOptions = pantryPanelController.text
//           .split(',')
//           .map((e) => e.trim())
//           .toList()
//         ..sort();
//       List<String> updatedNotOccupied = notOccupiedController.text
//           .split(',')
//           .map((e) => e.trim())
//           .toList()
//         ..sort();
//       List<String> updatedServiceVendor = serviceController.text
//           .split(',')
//           .map((e) => e.trim())
//           .toList()
//         ..sort(); // New list

//       await FirebaseFirestore.instance
//           .collection('settings')
//           .doc('config')
//           .set({
//         'roomOptions': updatedRoomOptions,
//         'pantrypanelOptions': updatedPantryPanelOptions,
//         'notOccupiedStatuses': updatedNotOccupied,
//         'serviceVendor': updatedServiceVendor, // Save Service data
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Settings saved successfully'),
//         ));
//       }
//     } catch (e) {
//       log('Error saving settings: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchSettings();
//     log(roomOptions.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: roomController,
//               decoration: const InputDecoration(
//                   labelText: 'Room Options (comma separated)'),
//               maxLines: null,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: pantryPanelController,
//               decoration: const InputDecoration(
//                   labelText: 'PantryPanel Options (comma separated)'),
//               maxLines: null,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: notOccupiedController,
//               decoration: const InputDecoration(
//                   labelText: 'Not Occupied Statuses (comma separated)'),
//               maxLines: null,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: serviceController,
//               decoration: const InputDecoration(
//                   labelText:
//                       'Service Vendor (comma separated)'), // New TextField
//               maxLines: null,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _saveSettings,
//               child: const Text('Save Settings'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   Map<String, List<String>> categorizedOptions = {
//     "Room": [],
//     "Pantry/Panel": [],
//     "Store": [],
//     "Service Vendor": [],
//     "Not Occupied": []
//   };

//   String selectedCategory = "Room";
//   final TextEditingController newItemController = TextEditingController();

//   // Fetch data from Firestore
//   Future<void> _fetchSettings() async {
//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('settings')
//           .doc('config2')
//           .get();

//       if (docSnapshot.exists) {
//         setState(() {
//           categorizedOptions = Map<String, List<String>>.from(
//             docSnapshot.data()!.map(
//                   (key, value) => MapEntry(key, List<String>.from(value)),
//                 ),
//           );
//         });
//       }
//     } catch (e) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error fetching settings: $e"),
//       ));
//     }
//   }

//   // Save data to Firestore
//   Future<void> _saveSettings() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('settings')
//           .doc('config2')
//           .set(categorizedOptions);

//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Settings saved successfully"),
//       ));
//     } catch (e) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error saving settings: $e"),
//       ));
//     }
//   }

//   // Add a new item to the selected category
//   void _addItem() {
//     final newItem = newItemController.text.trim();
//     if (newItem.isNotEmpty) {
//       setState(() {
//         categorizedOptions[selectedCategory]!.add(newItem);
//         newItemController.clear();
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchSettings(); // Fetch settings when the page loads
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Input and Save Settings")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Dropdown to select category
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               decoration: const InputDecoration(labelText: 'Select Category'),
//               items: categorizedOptions.keys
//                   .map((category) => DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     selectedCategory = value;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             // TextField to add a new item
//             TextField(
//               controller: newItemController,
//               decoration: InputDecoration(
//                 labelText: 'New Item for $selectedCategory',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: _addItem,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // ListView to display items in the selected category
//             Expanded(
//               child: ListView.builder(
//                 itemCount: categorizedOptions[selectedCategory]!.length,
//                 itemBuilder: (context, index) {
//                   final item = categorizedOptions[selectedCategory]![index];
//                   return ListTile(
//                     title: Text(item),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         setState(() {
//                           categorizedOptions[selectedCategory]!.removeAt(index);
//                         });
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Button to save settings
//             ElevatedButton(
//               onPressed: _saveSettings,
//               child: const Text("Save Settings"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   Map<String, List<String>> categorizedOptions = {
//     "Room": [],
//     "Pantry/Panel": [],
//     "Store": [],
//     "Service Vendor": [],
//     "Not Occupied": ["Store LT2"]
//   };

//   String selectedCategory = "Room";
//   final TextEditingController newItemController = TextEditingController();

//   // Fetch data from Firestore
//   Future<void> _fetchSettings() async {
//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('settings')
//           .doc('config2')
//           .get();

//       if (docSnapshot.exists) {
//         setState(() {
//           categorizedOptions = Map<String, List<String>>.from(
//             docSnapshot.data()!.map(
//                   (key, value) => MapEntry(key, List<String>.from(value)),
//                 ),
//           );
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error fetching settings: $e"),
//       ));
//     }
//   }

//   // Save data to Firestore
//   Future<void> _saveSettings() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('settings')
//           .doc('config2')
//           .set(categorizedOptions);

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Settings saved successfully"),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error saving settings: $e"),
//       ));
//     }
//   }

//   // Add a new item to the selected category
//   void _addItem() {
//     final newItem = newItemController.text.trim();
//     if (newItem.isNotEmpty) {
//       setState(() {
//         categorizedOptions[selectedCategory]!.add(newItem);
//         newItemController.clear();
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchSettings(); // Fetch settings when the page loads
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Input and Save Settings")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Dropdown to select category
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               decoration: const InputDecoration(labelText: 'Select Category'),
//               items: categorizedOptions.keys
//                   .map((category) => DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     selectedCategory = value;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             // TextField to add a new item
//             TextField(
//               controller: newItemController,
//               decoration: InputDecoration(
//                 labelText: 'New Item for $selectedCategory',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: _addItem,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // ListView to display items in the selected category
//             Expanded(
//               child: ListView.builder(
//                 itemCount: categorizedOptions[selectedCategory]!.length,
//                 itemBuilder: (context, index) {
//                   final item = categorizedOptions[selectedCategory]![index];
//                   return ListTile(
//                     title: Text(item),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         setState(() {
//                           categorizedOptions[selectedCategory]!.removeAt(index);
//                         });
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Button to save settings
//             ElevatedButton(
//               onPressed: _saveSettings,
//               child: const Text("Save Settings"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Map<String, List<String>> categorizedOptions = {
  //   "Room": [
  //     "Argon I",
  //     "Argon II",
  //     "Atmosphere",
  //     "Ballroom A",
  //     "Ballroom B",
  //     "Crypton",
  //     "East Destination",
  //     "FO Office",
  //     "Food Exchange",
  //     "Grand Argon",
  //     "Grand Ballroom",
  //     "Grand Destination",
  //     "Helium",
  //     "Hydrogen",
  //     "Main Destination",
  //     "Neon",
  //     "Nitrogen",
  //     "not use",
  //     "Oxygen",
  //     "Pantry / Panel Heritage",
  //     "Pantry / Panel Lantai3",
  //     "Pantry / Panel Lantai5",
  //     "Pantry / Panel Una²",
  //     "Plataran",
  //     "VIP Ballroom",
  //     "Store LT2",
  //     "West Destination",
  //     "Una Una Exec Lounge",
  //     "Una Una GD",
  //     "The Heritage",
  //     "Xenon"
  //   ],
  //   "Pantry/Panel": [
  //     "Pantry / Panel Heritage",
  //     "Pantry / Panel Lantai3",
  //     "Pantry / Panel Lantai5",
  //     "Pantry / Panel Una²",
  //   ],
  //   "Store": ["Store LT2"],
  //   "Service Vendor": ["DRM"],
  //   "Not Occupied": [
  //     "Pantry / Panel Heritage",
  //     "Pantry / Panel Lantai3",
  //     "Pantry / Panel Lantai5",
  //     "Pantry / Panel Una²",
  //     "Store LT2",
  //   ]
  // };

  Map<String, List<String>> categorizedOptions = {
    "Room": [],
    "Pantry/Panel": [],
    "Store": [],
    "Service Vendor": [],
  };

  String selectedCategory = "Room";
  final TextEditingController newItemController = TextEditingController();

  // Fetch settings from Firestore
  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('config2')
          .get();

      if (snapshot.exists) {
        setState(() {
          final data = snapshot.data() as Map<String, dynamic>;
          categorizedOptions = data.map((key, value) =>
              MapEntry(key, List<String>.from(value as List<dynamic>)));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error fetching settings: $e"),
        ));
      }
    }

    // log("CategorizedOptions: $categorizedOptions");
    // List<String> roomOptions = categorizedOptions["Room"] ?? [];
    // log("Room Options: $roomOptions");
  }

  // Save settings to Firestore
  Future<void> _saveSettings() async {
    try {
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('config2')
          .set(categorizedOptions);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
          elevation: 8,
          content: Text("Settings saved successfully"),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          elevation: 8,
          content: Text("Error saving settings: $e"),
        ));
      }
    }
  }

  // Add a new item to the selected category
  void _addItem() {
    final newItem = newItemController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        categorizedOptions[selectedCategory]!.add(newItem);
        newItemController.clear();
      });
    }
  }

  void _showEditDialog(String item, int index) {
    String updatedItem = item;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: TextField(
            controller: TextEditingController(text: item),
            onChanged: (value) => updatedItem = value,
            decoration: const InputDecoration(labelText: 'Update Item'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  categorizedOptions[selectedCategory]![index] = updatedItem;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String getInitials(String text) {
    // Pisahkan teks menjadi kata-kata berdasarkan spasi
    final words = text.trim().split(' ');

    if (words.length > 1) {
      // Jika ada lebih dari satu kata, ambil huruf pertama dari dua kata pertama
      return words
          .take(2)
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
          .join();
    } else {
      // Jika hanya satu kata, ambil dua huruf pertama
      final singleWord =
          words.firstOrNull ?? ''; // Menghindari kesalahan jika string kosong
      return singleWord.length >= 2
          ? singleWord.substring(0, 2).toUpperCase()
          : singleWord.toUpperCase();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final sortedCategories = categorizedOptions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Button row to switch categories (square buttons)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sortedCategories.map((entry) {
                final category = entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    width: (screenWidth - 48) / 3, // Adjust for spacing
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.blue
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // TextField for adding a new item
            TextField(
              controller: newItemController,
              decoration: InputDecoration(
                labelText: 'New Item for $selectedCategory',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ListView for displaying items of the selected category
            // Expanded(
            //   child: ListView.builder(
            //     padding: const EdgeInsets.all(0),
            //     itemCount: categorizedOptions[selectedCategory]!.length,
            //     itemBuilder: (context, index) {
            //       final item = categorizedOptions[selectedCategory]![index];
            //       return ListTile(
            //         contentPadding: const EdgeInsets.symmetric(
            //             vertical: 0,
            //             horizontal: 16.0), // Mengurangi padding vertikal
            //         title: Text(item),
            //         trailing: IconButton(
            //           icon: const Icon(Icons.delete, color: Colors.red),
            //           onPressed: () {
            //             setState(() {
            //               categorizedOptions[selectedCategory]!.removeAt(index);
            //             });
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: categorizedOptions[selectedCategory]!.length,
                itemBuilder: (context, index) {
                  final item = categorizedOptions[selectedCategory]![index];
                  // final itemInitials = item.isNotEmpty
                  //     ? item.substring(0, 2).toUpperCase()
                  //     : ''; // Mengambil 2 huruf pertama item

                  return Dismissible(
                    key: Key(item), // Kunci unik untuk widget Dismissible
                    background: Container(
                      color: Colors.blue, // Warna untuk tombol Edit
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20.0),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red, // Warna untuk tombol Remove
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Tindakan untuk Edit
                        _showEditDialog(item, index);
                        return false; // Jangan hapus item saat mengedit
                      } else if (direction == DismissDirection.endToStart) {
                        // Tindakan untuk Remove
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to remove this item?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Remove'),
                                ),
                              ],
                            );
                          },
                        );
                        return confirm ?? false; // Hapus item jika dikonfirmasi
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        // Menghapus item dari kategori jika dihapus
                        setState(() {
                          categorizedOptions[selectedCategory]!.removeAt(index);
                        });
                      }
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16.0, // Mengurangi padding vertikal
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            Colors.blue, // Warna latar belakang avatar
                        child: Text(
                          getInitials(
                              item), // Fungsi untuk mendapatkan inisial dari item
                          style: const TextStyle(
                            color: Colors.white,
                          ), // Menyesuaikan warna teks
                        ),
                      ),
                      title: Text(item),
                    ),
                  );
                },
              ),
            ),

            // Expanded(
            //   child: GridView.builder(
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 3, // Jumlah kolom
            //       crossAxisSpacing: 8.0, // Spasi horizontal antar item
            //       mainAxisSpacing: 4.0, // Spasi vertikal antar item
            //     ),
            //     itemCount: categorizedOptions[selectedCategory]!.length,
            //     itemBuilder: (context, index) {
            //       final item = categorizedOptions[selectedCategory]![index];
            //       return Card(
            //         margin: const EdgeInsets.all(
            //             4.0), // Mengurangi margin sekitar item
            //         child: ListTile(
            //           title: Text(item),
            //           trailing: IconButton(
            //             icon: const Icon(Icons.delete, color: Colors.red),
            //             onPressed: () {
            //               setState(() {
            //                 categorizedOptions[selectedCategory]!
            //                     .removeAt(index);
            //               });
            //             },
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // Save settings button
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text("Save Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
