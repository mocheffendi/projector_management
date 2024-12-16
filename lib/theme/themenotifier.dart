import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ThemeMode StateNotifier
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// Riverpod Provider for ThemeMode
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// StateNotifier untuk mengelola categorizedOptions
class CategorizedOptionsNotifier
    extends StateNotifier<Map<String, List<String>>> {
  CategorizedOptionsNotifier() : super({});

  void updateOptions(Map<String, dynamic> data) {
    state = data.map((key, value) =>
        MapEntry(key, List<String>.from(value as List<dynamic>)));
  }
}

final categorizedOptionsProvider = StateNotifierProvider<
    CategorizedOptionsNotifier, Map<String, List<String>>>(
  (ref) => CategorizedOptionsNotifier(),
);
