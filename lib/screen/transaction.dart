// import 'package:flutter/material.dart';

// class TransactionStatusPage extends StatelessWidget {
//   const TransactionStatusPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Status Transaksi'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Kamu menghemat Rp6.500 dari transaksi ini, lho! Mantap!',
//               style: TextStyle(fontSize: 16, color: Colors.teal),
//             ),
//             const SizedBox(height: 20),
//             const Card(
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'ID Transaksi #FT581027494',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Text('Transaksi berhasil diproses'),
//                     Text('29 November 2024 09:25 WIB'),
//                     SizedBox(height: 20),
//                     Text(
//                       'Rp1.900.000',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20),
//                     Divider(),
//                     SizedBox(height: 10),
//                     Text('Penerima',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text('Mochammad Effendi'),
//                     Text('Bank Penerima: BCA'),
//                     Text('Nomor Rekening: 1070463128'),
//                     SizedBox(height: 20),
//                     Text('Pengirim',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text('Mochammad Effendi'),
//                     Text('Transfer melalui: PT Fliptech Lentera'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Kegiatan transfer uang di Flip terlisensi oleh Bank Indonesia. Bertransaksi pun jadi lebih aman.',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.download),
//                   label: const Text('Unduh'),
//                   style:
//                       ElevatedButton.styleFrom(foregroundColor: Colors.orange),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.share),
//                   label: const Text('Bagikan'),
//                   style:
//                       ElevatedButton.styleFrom(foregroundColor: Colors.orange),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(foregroundColor: Colors.orange),
//                 child: const Text('Transfer Lagi ke Tujuan Ini'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TransactionStatusPage extends StatelessWidget {
  const TransactionStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'Kamu menghemat Rp6.500 dari transaksi ini, lho! Mantap!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ID Transaksi #FT581027494',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Transaksi berhasil diproses\n29 November 2024 09:25 WIB',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rp1.900.000',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 32),
                    buildDetailRow('Penerima', 'Mochammad Effendi'),
                    buildDetailRow('Bank Penerima', 'BCA'),
                    buildDetailRow('Nomor Rekening', '1070463128'),
                    buildDetailRow('Pengirim', 'Mochammad Effendi'),
                    buildDetailRow('Transfer melalui', 'PT Fliptech Lentera'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Unduh'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Bagikan'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
              child: const Text('Transfer Lagi ke Tujuan Ini'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
