// import 'package:flutter/material.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/1.png',
//     },
//     {
//       'image': 'assets/avspecification/2.png',
//     },
//     {
//       'image': 'assets/avspecification/3.png',
//     },
//     {
//       'image': 'assets/avspecification/4.png',
//     },
//     {
//       'image': 'assets/avspecification/5.png',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.8);

//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: PageView.builder(
//               controller: controller,
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return AnimatedBuilder(
//                   animation: controller,
//                   builder: (context, child) {
//                     double value = 0.0;
//                     if (controller.position.haveDimensions) {
//                       value = index - controller.page!;
//                       value = (value * 0.3).clamp(-1, 1);
//                     }

//                     return Transform.scale(
//                       scale: 1 - (value.abs() * 0.2),
//                       child: child,
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 24),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.5),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                         color: Colors.grey[900],
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Add additional widgets here if needed
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/1.png',
//     },
//     {
//       'image': 'assets/avspecification/2.png',
//     },
//     {
//       'image': 'assets/avspecification/3.png',
//     },
//     {
//       'image': 'assets/avspecification/4.png',
//     },
//     {
//       'image': 'assets/avspecification/5.png',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.8);

//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: PageView.builder(
//               controller: controller,
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return AnimatedBuilder(
//                   animation: controller,
//                   builder: (context, child) {
//                     double value = 0.0;
//                     if (controller.position.haveDimensions) {
//                       value = index - controller.page!;
//                       value = (value * 0.3).clamp(-1, 1);
//                     }

//                     return Transform.scale(
//                       scale: 1 - (value.abs() * 0.2),
//                       child: child,
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 24),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.5),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                         color: Colors.grey[900],
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.asset(
//                                 item['image']!,
//                                 fit: BoxFit.fill,
//                                 width: double.infinity,
//                                 height: 400,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Center(
//                                   child: Icon(Icons.error, color: Colors.red),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/1.png',
//     },
//     {
//       'image': 'assets/avspecification/2.png',
//     },
//     {
//       'image': 'assets/avspecification/3.png',
//     },
//     {
//       'image': 'assets/avspecification/4.png',
//     },
//     {
//       'image': 'assets/avspecification/5.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.8);

//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: PageView.builder(
//               controller: controller,
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return AnimatedBuilder(
//                   animation: controller,
//                   builder: (context, child) {
//                     double value = 0.0;
//                     if (controller.position.haveDimensions) {
//                       value = index - controller.page!;
//                       value = (value * 0.3).clamp(-1, 1);
//                     }

//                     return Transform.scale(
//                       scale: 1 - (value.abs() * 0.2),
//                       child: child,
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 24),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.5),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                         color: Colors.grey[900],
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           item['image']!,
//                           fit: BoxFit.fill,
//                           width: double.infinity,
//                           height: 400,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Center(
//                             child: Icon(Icons.error, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             onPressed: () async {
//                               final imagePath = item['image'];
//                               if (imagePath != null) {
//                                 await _shareImageFromMemory(imagePath);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Image path not found!'),
//                                   ),
//                                 );
//                               }
//                             },
//                             icon: const Icon(Icons.share),
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/1.png',
//     },
//     {
//       'image': 'assets/avspecification/2.png',
//     },
//     {
//       'image': 'assets/avspecification/3.png',
//     },
//     {
//       'image': 'assets/avspecification/4.png',
//     },
//     {
//       'image': 'assets/avspecification/5.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfYear = DateTime(now.year, 1, 1);
//     final endOfYear = DateTime(2026, 1, 1);

//     final totalDays = endOfYear.difference(startOfYear).inDays;
//     final elapsedDays = now.difference(startOfYear).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.8);

//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '${_calculatePercentageTo2026().toStringAsFixed(2)}% of the way to 2026!',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                   // const TextStyle(
//                   //   fontSize: 18,
//                   //   fontWeight: FontWeight.bold,
//                   // ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: PageView.builder(
//               controller: controller,
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return AnimatedBuilder(
//                   animation: controller,
//                   builder: (context, child) {
//                     double value = 0.0;
//                     if (controller.position.haveDimensions) {
//                       value = index - controller.page!;
//                       value = (value * 0.3).clamp(-1, 1);
//                     }

//                     return Transform.scale(
//                       scale: 1 - (value.abs() * 0.2),
//                       child: child,
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 24),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.5),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                         color: Colors.grey[900],
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           item['image']!,
//                           fit: BoxFit.fill,
//                           width: double.infinity,
//                           height: 400,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Center(
//                             child: Icon(Icons.error, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             onPressed: () async {
//                               final imagePath = item['image'];
//                               if (imagePath != null) {
//                                 await _shareImageFromMemory(imagePath);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Image path not found!'),
//                                   ),
//                                 );
//                               }
//                             },
//                             icon: const Icon(Icons.share),
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/1.png',
//     },
//     {
//       'image': 'assets/avspecification/2.png',
//     },
//     {
//       'image': 'assets/avspecification/3.png',
//     },
//     {
//       'image': 'assets/avspecification/4.png',
//     },
//     {
//       'image': 'assets/avspecification/5.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfYear = DateTime(now.year, 1, 1);
//     final endOfYear = DateTime(2026, 1, 1);

//     final totalDays = endOfYear.difference(startOfYear).inDays;
//     final elapsedDays = now.difference(startOfYear).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Good Morning Heartist';
//     } else if (hour < 18) {
//       return 'Good Afternoon Heartist';
//     } else {
//       return 'Good Evening Heartist';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.8);

//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   _getGreeting(),
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 8.0),
//                 Text(
//                   '${_calculatePercentageTo2026().toStringAsFixed(2)}% of the way to 2026',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: PageView.builder(
//               controller: controller,
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return AnimatedBuilder(
//                   animation: controller,
//                   builder: (context, child) {
//                     double value = 0.0;
//                     if (controller.position.haveDimensions) {
//                       value = index - controller.page!;
//                       value = (value * 0.3).clamp(-1, 1);
//                     }

//                     return Transform.scale(
//                       scale: 1 - (value.abs() * 0.2),
//                       child: child,
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 24),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.5),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                         color: Colors.grey[900],
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           item['image']!,
//                           fit: BoxFit.fill,
//                           width: double.infinity,
//                           height: 400,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Center(
//                             child: Icon(Icons.error, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             onPressed: () async {
//                               final imagePath = item['image'];
//                               if (imagePath != null) {
//                                 await _shareImageFromMemory(imagePath);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Image path not found!'),
//                                   ),
//                                 );
//                               }
//                             },
//                             icon: const Icon(Icons.share),
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems1 = [
//     {
//       'image': 'assets/novotel/1.png',
//     },
//     {
//       'image': 'assets/novotel/2.png',
//     },
//     {
//       'image': 'assets/novotel/3.png',
//     },
//     {
//       'image': 'assets/novotel/4.png',
//     },
//     {
//       'image': 'assets/novotel/5.png',
//     },
//   ];

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/1.png',
//     },
//     {
//       'image': 'assets/avspecification/2.png',
//     },
//     {
//       'image': 'assets/avspecification/3.png',
//     },
//     {
//       'image': 'assets/avspecification/4.png',
//     },
//     {
//       'image': 'assets/avspecification/5.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfYear = DateTime(now.year, 1, 1);
//     final endOfYear = DateTime(2026, 1, 1);

//     final totalDays = endOfYear.difference(startOfYear).inDays;
//     final elapsedDays = now.difference(startOfYear).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Hi Good Morning Heartist';
//     } else if (hour < 18) {
//       return 'Hi Good Afternoon Heartist';
//     } else {
//       return 'Hi Good Evening Heartist';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.8);
//     final double progressPercentage = _calculatePercentageTo2026();

//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _getGreeting(),
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 8.0),
//                 Text(
//                   '${progressPercentage.toStringAsFixed(2)}% of the way to 2026',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const SizedBox(height: 8.0),
//                 LinearProgressIndicator(
//                   value: progressPercentage / 100,
//                   minHeight: 10,
//                   backgroundColor: Colors.grey[300],
//                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: PageView.builder(
//               controller: controller,
//               itemCount: sliderItems1.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems1[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       // boxShadow: [
//                       //   BoxShadow(
//                       //     color: Colors.black.withOpacity(0.5),
//                       //     blurRadius: 8,
//                       //     offset: const Offset(0, 4),
//                       //   ),
//                       // ],
//                       color: Colors.grey[900],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.asset(
//                         item['image']!,
//                         fit: BoxFit.fill,
//                         // height: 160,
//                         width: double.infinity,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Center(
//                           child: Icon(Icons.error, color: Colors.red),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: sliderItems.length,
//               itemBuilder: (context, index) {
//                 final item = sliderItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           item['image']!,
//                           fit: BoxFit.fill,
//                           width: double.infinity,
//                           height: 400,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Center(
//                             child: Icon(Icons.error, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             onPressed: () async {
//                               final imagePath = item['image'];
//                               if (imagePath != null) {
//                                 await _shareImageFromMemory(imagePath);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Image path not found!'),
//                                   ),
//                                 );
//                               }
//                             },
//                             icon: const Icon(Icons.share),
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems1 = [
//     {
//       'image': 'assets/novotel/1.png',
//     },
//     {
//       'image': 'assets/novotel/2.png',
//     },
//     {
//       'image': 'assets/novotel/3.png',
//     },
//     {
//       'image': 'assets/novotel/4.png',
//     },
//     {
//       'image': 'assets/novotel/5.png',
//     },
//   ];

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/6.png',
//     },
//     {
//       'image': 'assets/avspecification/7.png',
//     },
//     {
//       'image': 'assets/avspecification/8.png',
//     },
//     {
//       'image': 'assets/avspecification/9.png',
//     },
//     {
//       'image': 'assets/avspecification/10.png',
//     },
//     {
//       'image': 'assets/avspecification/11.png',
//     },
//     {
//       'image': 'assets/avspecification/12.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   // double _calculatePercentageTo2026() {
//   //   final now = DateTime.now();
//   //   final startOfYear = DateTime(now.year, 1, 1);
//   //   final endOfYear = DateTime(now.year + 1, 1, 1);

//   //   final totalDays = endOfYear.difference(startOfYear).inDays;
//   //   final elapsedDays = now.difference(startOfYear).inDays;

//   //   return (elapsedDays / totalDays) * 100;
//   // }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfMonth = DateTime(now.year, now.month, 1);
//     final endOfMonth = DateTime(now.year, now.month + 1, 1);

//     final totalDays = endOfMonth.difference(startOfMonth).inDays;
//     final elapsedDays = now.difference(startOfMonth).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Hi Good Morning Heartist';
//     } else if (hour < 18) {
//       return 'Hi Good Afternoon Heartist';
//     } else {
//       return 'Hi Good Evening Heartist';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double progressPercentage = _calculatePercentageTo2026();
//     final monthNames = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     final nextMonth = monthNames[DateTime.now().month % 12];

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/bg.jpg', // Replace with your background image path
//               fit: BoxFit.fill,
//             ),
//           ),
//           // Page content
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _getGreeting(),
//                         style: Theme.of(context).textTheme.headlineSmall,
//                       ),
//                       const SizedBox(height: 8.0),
//                       Container(
//                         padding: const EdgeInsets.all(8.0),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.grey)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Progress ${progressPercentage.toStringAsFixed(0)}% on the way to $nextMonth',
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                             const SizedBox(height: 8.0),
//                             LinearProgressIndicator(
//                               value: progressPercentage / 100,
//                               minHeight: 10,
//                               backgroundColor: Colors.grey[300],
//                               valueColor: const AlwaysStoppedAnimation<Color>(
//                                   Colors.blue),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: 160.0,
//                     enlargeCenterPage: true,
//                     autoPlay: true,
//                     aspectRatio: 16 / 9,
//                     autoPlayCurve: Curves.fastOutSlowIn,
//                     enableInfiniteScroll: true,
//                     autoPlayAnimationDuration:
//                         const Duration(milliseconds: 800),
//                     viewportFraction: 0.8,
//                   ),
//                   items: sliderItems1.map((item) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: Colors.grey[900],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.fill,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: sliderItems.length,
//                     itemBuilder: (context, index) {
//                       final item = sliderItems[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.asset(
//                                 item['image']!,
//                                 fit: BoxFit.fill,
//                                 width: double.infinity,
//                                 height: 400,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Center(
//                                   child: Icon(Icons.error, color: Colors.red),
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IconButton(
//                                   onPressed: () async {
//                                     final imagePath = item['image'];
//                                     if (imagePath != null) {
//                                       await _shareImageFromMemory(imagePath);
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         const SnackBar(
//                                           content:
//                                               Text('Image path not found!'),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   icon: const Icon(Icons.share),
//                                   color: Colors.blue,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:photo_view/photo_view.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems1 = [
//     {
//       'image': 'assets/novotel/1.png',
//     },
//     {
//       'image': 'assets/novotel/2.png',
//     },
//     {
//       'image': 'assets/novotel/3.png',
//     },
//     {
//       'image': 'assets/novotel/4.png',
//     },
//     {
//       'image': 'assets/novotel/5.png',
//     },
//   ];

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/6.png',
//     },
//     {
//       'image': 'assets/avspecification/7.png',
//     },
//     {
//       'image': 'assets/avspecification/8.png',
//     },
//     {
//       'image': 'assets/avspecification/9.png',
//     },
//     {
//       'image': 'assets/avspecification/10.png',
//     },
//     {
//       'image': 'assets/avspecification/11.png',
//     },
//     {
//       'image': 'assets/avspecification/12.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfMonth = DateTime(now.year, now.month, 1);
//     final endOfMonth = DateTime(now.year, now.month + 1, 1);

//     final totalDays = endOfMonth.difference(startOfMonth).inDays;
//     final elapsedDays = now.difference(startOfMonth).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Hi Good Morning Heartist';
//     } else if (hour < 18) {
//       return 'Hi Good Afternoon Heartist';
//     } else {
//       return 'Hi Good Evening Heartist';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double progressPercentage = _calculatePercentageTo2026();
//     final monthNames = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     final nextMonth = monthNames[DateTime.now().month % 12];

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/bg.jpg', // Replace with your background image path
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Page content
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _getGreeting(),
//                         style: Theme.of(context).textTheme.headlineSmall,
//                       ),
//                       const SizedBox(height: 8.0),
//                       Container(
//                         padding: const EdgeInsets.all(8.0),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.grey)),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Progress ${progressPercentage.toStringAsFixed(0)}% on the way to $nextMonth',
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                             const SizedBox(height: 8.0),
//                             LinearProgressIndicator(
//                               value: progressPercentage / 100,
//                               minHeight: 10,
//                               backgroundColor: Colors.grey[300],
//                               valueColor: const AlwaysStoppedAnimation<Color>(
//                                   Colors.blue),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: 160.0,
//                     enlargeCenterPage: true,
//                     autoPlay: true,
//                     aspectRatio: 16 / 9,
//                     autoPlayCurve: Curves.fastOutSlowIn,
//                     enableInfiniteScroll: true,
//                     autoPlayAnimationDuration:
//                         const Duration(milliseconds: 800),
//                     viewportFraction: 0.8,
//                   ),
//                   items: sliderItems1.map((item) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: Colors.grey[900],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.fill,
//                               width: double.infinity,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: sliderItems.length,
//                   itemBuilder: (context, index) {
//                     final item = sliderItems[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: SizedBox(
//                               height: 460,
//                               width: 600,
//                               child: PhotoView(
//                                 imageProvider: AssetImage(item['image']!),
//                                 backgroundDecoration: BoxDecoration(
//                                   color: Theme.of(context).canvasColor,
//                                 ),
//                                 basePosition: Alignment.center,
//                                 scaleStateController:
//                                     PhotoViewScaleStateController(),
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Center(
//                                   child: Icon(Icons.error, color: Colors.red),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               IconButton(
//                                 onPressed: () async {
//                                   final imagePath = item['image'];
//                                   if (imagePath != null) {
//                                     await _shareImageFromMemory(imagePath);
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content:
//                                             Text('Image share successfully'),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('Image path not found!'),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 icon: const Icon(Icons.share),
//                                 color: Colors.blue,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems1 = [
//     {
//       'image': 'assets/novotel/1.png',
//     },
//     {
//       'image': 'assets/novotel/2.png',
//     },
//     {
//       'image': 'assets/novotel/3.png',
//     },
//     {
//       'image': 'assets/novotel/4.png',
//     },
//     {
//       'image': 'assets/novotel/5.png',
//     },
//   ];

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/6.png',
//     },
//     {
//       'image': 'assets/avspecification/7.png',
//     },
//     {
//       'image': 'assets/avspecification/8.png',
//     },
//     {
//       'image': 'assets/avspecification/9.png',
//     },
//     {
//       'image': 'assets/avspecification/10.png',
//     },
//     {
//       'image': 'assets/avspecification/11.png',
//     },
//     {
//       'image': 'assets/avspecification/12.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   // double _calculatePercentageTo2026() {
//   //   final now = DateTime.now();
//   //   final startOfYear = DateTime(now.year, 1, 1);
//   //   final endOfYear = DateTime(now.year + 1, 1, 1);

//   //   final totalDays = endOfYear.difference(startOfYear).inDays;
//   //   final elapsedDays = now.difference(startOfYear).inDays;

//   //   return (elapsedDays / totalDays) * 100;
//   // }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfMonth = DateTime(now.year, now.month, 1);
//     final endOfMonth = DateTime(now.year, now.month + 1, 1);

//     final totalDays = endOfMonth.difference(startOfMonth).inDays;
//     final elapsedDays = now.difference(startOfMonth).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Hi Good Morning Heartist';
//     } else if (hour < 18) {
//       return 'Hi Good Afternoon Heartist';
//     } else {
//       return 'Hi Good Evening Heartist';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double progressPercentage = _calculatePercentageTo2026();
//     final monthNames = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     final nextMonth = monthNames[DateTime.now().month % 12];

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/bg.jpg', // Replace with your background image path
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Page content
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _getGreeting(),
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 8.0),
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.grey)),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Progress ${progressPercentage.toStringAsFixed(0)}% on the way to $nextMonth',
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                           const SizedBox(height: 8.0),
//                           LinearProgressIndicator(
//                             value: progressPercentage / 100,
//                             minHeight: 10,
//                             backgroundColor: Colors.grey[300],
//                             valueColor: const AlwaysStoppedAnimation<Color>(
//                                 Colors.blue),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 160.0,
//                   enlargeCenterPage: true,
//                   autoPlay: true,
//                   aspectRatio: 16 / 9,
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   enableInfiniteScroll: true,
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                   viewportFraction: 0.8,
//                 ),
//                 items: sliderItems1.map((item) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Colors.grey[900],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.asset(
//                             item['image']!,
//                             fit: BoxFit.fill,
//                             width: double.infinity,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Center(
//                               child: Icon(Icons.error, color: Colors.red),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: sliderItems.length,
//                   itemBuilder: (context, index) {
//                     final item = sliderItems[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.asset(
//                               item['image']!,
//                               fit: BoxFit.fill,
//                               width: double.infinity,
//                               height: 400,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Center(
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               IconButton(
//                                 onPressed: () async {
//                                   final imagePath = item['image'];
//                                   if (imagePath != null) {
//                                     await _shareImageFromMemory(imagePath);
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('Image path not found!'),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 icon: const Icon(Icons.share),
//                                 color: Colors.blue,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';

// class AVSpecificationPage extends StatelessWidget {
//   AVSpecificationPage({super.key});

//   final List<Map<String, String>> sliderItems1 = [
//     {
//       'image': 'assets/novotel/1.png',
//     },
//     {
//       'image': 'assets/novotel/2.png',
//     },
//     {
//       'image': 'assets/novotel/3.png',
//     },
//     {
//       'image': 'assets/novotel/4.png',
//     },
//     {
//       'image': 'assets/novotel/5.png',
//     },
//   ];

//   final List<Map<String, String>> sliderItems = [
//     {
//       'image': 'assets/avspecification/6.png',
//     },
//     {
//       'image': 'assets/avspecification/7.png',
//     },
//     {
//       'image': 'assets/avspecification/8.png',
//     },
//     {
//       'image': 'assets/avspecification/9.png',
//     },
//     {
//       'image': 'assets/avspecification/10.png',
//     },
//     {
//       'image': 'assets/avspecification/11.png',
//     },
//     {
//       'image': 'assets/avspecification/12.png',
//     },
//   ];

//   Future<void> _shareImageFromMemory(String assetPath) async {
//     try {
//       // Load image bytes from the asset
//       final ByteData byteData = await rootBundle.load(assetPath);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       // Share the image bytes directly
//       await Share.shareXFiles([
//         XFile.fromData(bytes,
//             name: assetPath.split('/').last, mimeType: 'image/png'),
//       ], text: 'Check out this image!');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   double _calculatePercentageTo2026() {
//     final now = DateTime.now();
//     final startOfMonth = DateTime(now.year, now.month, 1);
//     final endOfMonth = DateTime(now.year, now.month + 1, 1);

//     final totalDays = endOfMonth.difference(startOfMonth).inDays;
//     final elapsedDays = now.difference(startOfMonth).inDays;

//     return (elapsedDays / totalDays) * 100;
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Hi Good Morning Heartist';
//     } else if (hour < 18) {
//       return 'Hi Good Afternoon Heartist';
//     } else {
//       return 'Hi Good Evening Heartist';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double progressPercentage = _calculatePercentageTo2026();
//     final monthNames = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     final nextMonth = monthNames[DateTime.now().month % 12];

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/bg.jpg', // Replace with your background image path
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Page content
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _getGreeting(),
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 8.0),
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.grey)),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Progress ${progressPercentage.toStringAsFixed(0)}% on the way to $nextMonth',
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                           const SizedBox(height: 8.0),
//                           LinearProgressIndicator(
//                             value: progressPercentage / 100,
//                             minHeight: 10,
//                             backgroundColor: Colors.grey[300],
//                             valueColor: const AlwaysStoppedAnimation<Color>(
//                                 Colors.blue),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 160.0,
//                   enlargeCenterPage: true,
//                   autoPlay: true,
//                   aspectRatio: 16 / 9,
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   enableInfiniteScroll: true,
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                   viewportFraction: 0.8,
//                 ),
//                 items: sliderItems1.map((item) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Colors.grey[900],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.asset(
//                             item['image']!,
//                             fit: BoxFit.fill,
//                             width: double.infinity,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Center(
//                               child: Icon(Icons.error, color: Colors.red),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: sliderItems.length,
//                   itemBuilder: (context, index) {
//                     final item = sliderItems[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ImageDetailPage(
//                                     imagePath: item['image']!,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Hero(
//                               tag: item['image']!,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.asset(
//                                   item['image']!,
//                                   fit: BoxFit.fill,
//                                   width: double.infinity,
//                                   height: 400,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       const Center(
//                                     child: Icon(Icons.error, color: Colors.red),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               IconButton(
//                                 onPressed: () async {
//                                   final imagePath = item['image'];
//                                   if (imagePath != null) {
//                                     await _shareImageFromMemory(imagePath);
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('Image path not found!'),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 icon: const Icon(Icons.share),
//                                 color: Colors.blue,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ImageDetailPage extends StatelessWidget {
//   final String imagePath;

//   const ImageDetailPage({required this.imagePath, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Hero(
//           tag: imagePath,
//           child: PhotoView(
//             imageProvider: AssetImage(imagePath),
//             backgroundDecoration: const BoxDecoration(
//               color: Colors.black,
//             ),
//             errorBuilder: (context, error, stackTrace) => const Center(
//               child: Icon(Icons.error, color: Colors.red),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class AVSpecificationPage extends StatelessWidget {
  AVSpecificationPage({super.key});

  final List<Map<String, String>> sliderItems1 = [
    {
      'image': 'assets/novotel/1.png',
    },
    {
      'image': 'assets/novotel/2.png',
    },
    {
      'image': 'assets/novotel/3.png',
    },
    {
      'image': 'assets/novotel/4.png',
    },
    {
      'image': 'assets/novotel/5.png',
    },
  ];

  final List<Map<String, String>> sliderItems = [
    {
      'image': 'assets/avspecification/6.png',
    },
    {
      'image': 'assets/avspecification/7.png',
    },
    {
      'image': 'assets/avspecification/8.png',
    },
    {
      'image': 'assets/avspecification/9.png',
    },
    {
      'image': 'assets/avspecification/10.png',
    },
    {
      'image': 'assets/avspecification/11.png',
    },
    {
      'image': 'assets/avspecification/12.png',
    },
  ];

  Future<void> _shareImageFromMemory(String assetPath) async {
    try {
      // Load image bytes from the asset
      final ByteData byteData = await rootBundle.load(assetPath);
      final Uint8List bytes = byteData.buffer.asUint8List();

      // Share the image bytes directly
      await Share.shareXFiles([
        XFile.fromData(bytes,
            name: assetPath.split('/').last, mimeType: 'image/png'),
      ], text: 'Check out this image!');
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }

  double _calculatePercentageTo2026() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final totalDays = endOfMonth.difference(startOfMonth).inDays;
    final elapsedDays = now.difference(startOfMonth).inDays;

    return (elapsedDays / totalDays) * 100;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Hi Good Morning Heartist';
    } else if (hour < 18) {
      return 'Hi Good Afternoon Heartist';
    } else {
      return 'Hi Good Evening Heartist';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = _calculatePercentageTo2026();
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final nextMonth = monthNames[DateTime.now().month % 12];

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Page content
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress ${progressPercentage.toStringAsFixed(0)}% on the way to $nextMonth',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8.0),
                            LinearProgressIndicator(
                              value: progressPercentage / 100,
                              minHeight: 10,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 160.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: sliderItems1.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[900],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sliderItems.length,
                  itemBuilder: (context, index) {
                    final item = sliderItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageDetailPage(
                                    imagePath: item['image']!,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: item['image']!,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: 400,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final imagePath = item['image'];
                                  if (imagePath != null) {
                                    await _shareImageFromMemory(imagePath);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Image path not found!'),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.share),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  final String imagePath;

  const ImageDetailPage({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imagePath,
          child: PhotoView(
            imageProvider: AssetImage(imagePath),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
