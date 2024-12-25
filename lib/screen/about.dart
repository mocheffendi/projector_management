import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projector_management/theme/themenotifier.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final themeNotifier = ref.read(themeNotifierProvider.notifier);

      return Scaffold(
        extendBodyBehindAppBar: true, // Mengizinkan overlap dengan AppBar
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            systemNavigationBarDividerColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            statusBarColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent, // Transparan untuk overlap
          // backgroundColor:
          //     Theme.of(context).colorScheme.surfaceContainerHighest,
          title: const Text(
            'About',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(ref.watch(themeNotifierProvider) == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: themeNotifier.toggleTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo Section
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FullScreenImage(
                            imagePath: 'assets/images/eng.jpg',
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'profile-image',
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.purpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(6.0), // Border thickness
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/eng.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'AV Product Inventory and Management',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Version: 0.1.45',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text('Developed by: Mochammad Effendi',
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 2),
                          Text(
                            'Position: Engineering Attendance',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'About the Software',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This software helps you manage and track audiovisual product inventory with ease and efficiency. It is designed to simplify your workflow and enhance productivity.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
        // Theme.of(context).colorScheme.surfaceContainerHighest,
        // title: const Text(
        //   'About',
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        // actions: [
        //   IconButton(
        //     icon: Icon(ref.watch(themeNotifierProvider) == ThemeMode.light
        //         ? Icons.dark_mode
        //         : Icons.light_mode),
        //     onPressed: themeNotifier.toggleTheme,
        //   ),
        // ],
      ),
      body: Center(
        child: Hero(
          tag: 'profile-image',
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
