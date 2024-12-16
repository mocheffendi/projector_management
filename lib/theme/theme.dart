import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: const Color(0xff2196f3),
  ).copyWith(
    primary: const Color(0xff2196f3), // Warna utama
    secondary: Colors.green,
    tertiary: Colors.red,
    surface: const Color.fromARGB(255, 199, 192, 192),
    error: const Color(0xffd32f2f),
    onPrimary: Colors.blue.shade100,
    onSecondary: Colors.green.shade100,
    onTertiary: Colors.brown.shade100,
    onError: Colors.red,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.shade700,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    accentColor: const Color(0xff2196f3),
  ).copyWith(
    primary: const Color(0xff2196f3), // Warna utama
    secondary: const Color(0xffbbdefb),
    tertiary: Colors.red.shade100,
    surface: const Color(0xff121212),
    error: const Color(0xffcf6679),
    onPrimary: Colors.blue.shade900,
    onSecondary: Colors.green.shade900,
    onTertiary: Colors.brown.shade900,
    onError: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey.shade900,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade800,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
  ),
);
