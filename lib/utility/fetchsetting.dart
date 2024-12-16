import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, List<String>> categorizedOptions = {
  "Room": [],
  "Pantry/Panel": [],
  "Store": [],
  "Service Vendor": [],
};

String? selectedItem = 'DRM'; // Menyimpan item yang dipilih

List<String> roomOptions = [];
List<String> pantryPanel = [];
List<String> store = [];
List<String> notOccupiedStatuses = [];
List<String> serviceVendor = [];

Future<void> fetchSettings() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('config2')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      categorizedOptions = data.map((key, value) =>
          MapEntry(key, List<String>.from(value as List<dynamic>)));
    }
  } catch (e) {
    // log('Error fetching settings: $e');
  }

  roomOptions = categorizedOptions["Room"] ?? [];
  pantryPanel = categorizedOptions["Pantry/Panel"] ?? [];
  store = categorizedOptions["Store"] ?? [];
  serviceVendor = categorizedOptions["Service Vendor"] ?? [];
  notOccupiedStatuses = pantryPanel + store;
  // log("notOccupiedStatuses: $notOccupiedStatuses");
}
