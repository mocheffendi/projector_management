import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:projector_management/utility/shareimagefrommemory.dart';

class ImageDetailPage extends StatelessWidget {
  final String imagePath;

  const ImageDetailPage({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          // Theme.of(context).colorScheme.surfaceContainerHighest,
          systemNavigationBarDividerColor: Colors.black,
          // Theme.of(context).colorScheme.surfaceContainerHighest,
          statusBarColor: Colors.black,
          // Theme.of(context).colorScheme.surfaceContainerHighest,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              final image = imagePath;
              if (image.isNotEmpty) {
                await shareImageFromMemory(image);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image path not found!'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imagePath,
          child: PhotoView(
            imageProvider: AssetImage(imagePath),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
