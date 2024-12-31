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

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class AVSpecificationPage extends StatelessWidget {
  AVSpecificationPage({super.key});

  final List<Map<String, String>> sliderItems = [
    {
      'image': 'assets/avspecification/1.png',
    },
    {
      'image': 'assets/avspecification/2.png',
    },
    {
      'image': 'assets/avspecification/3.png',
    },
    {
      'image': 'assets/avspecification/4.png',
    },
    {
      'image': 'assets/avspecification/5.png',
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

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.8);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              controller: controller,
              itemCount: sliderItems.length,
              itemBuilder: (context, index) {
                final item = sliderItems[index];
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    double value = 0.0;
                    if (controller.position.haveDimensions) {
                      value = index - controller.page!;
                      value = (value * 0.3).clamp(-1, 1);
                    }

                    return Transform.scale(
                      scale: 1 - (value.abs() * 0.2),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        color: Colors.grey[900],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sliderItems.length,
              itemBuilder: (context, index) {
                final item = sliderItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
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
          ),
        ],
      ),
    );
  }
}
