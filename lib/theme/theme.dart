import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Roboto', // Font default untuk semua teks
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: const Color(0xff2196f3),
  ).copyWith(
    primary: const Color(0xff2196f3), // on Service StatusColor
    secondary: Colors.green, // not Occupied statusColor
    tertiary: Colors.red, // Occupied statusColor
    surface: const Color.fromARGB(255, 238, 254, 255),
    error: const Color(0xffd32f2f),
    onPrimary: Colors.blue.shade100, // on Service CardColor
    onSecondary: Colors.green.shade100, // not Occupied cardColor
    onTertiary: Colors.red.shade100, // Occupied CardColor
    onError: Colors.red,
    surfaceContainerHighest: Colors.blue.shade700,
    tertiaryFixed: Colors.grey.shade300,
    onTertiaryFixed: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
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
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(
        color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
    labelLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    labelSmall: TextStyle(color: Colors.blue),
    labelMedium: TextStyle(color: Colors.blue),
    titleMedium: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  ),
  navigationBarTheme: NavigationBarThemeData(
    iconTheme: const WidgetStatePropertyAll(IconThemeData(
      color: Colors.white,
    )),
    backgroundColor: Colors.blue.shade700,
    labelTextStyle: const WidgetStatePropertyAll(
      TextStyle(color: Colors.white),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Roboto', // Font default untuk semua teks
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    accentColor: const Color(0xff2196f3),
  ).copyWith(
    primary: const Color(0xff2196f3), // Warna utama
    secondary: Colors.green,
    tertiary: Colors.red,
    surface: const Color.fromARGB(255, 46, 44, 44),
    error: const Color(0xffcf6679),
    onPrimary: Colors.blue.shade900,
    onSecondary: Colors.green.shade900,
    onTertiary: Colors.red.shade900,
    onError: Colors.black,
    surfaceContainerHighest: Colors.blueGrey.shade900,
    tertiaryFixed: Colors.grey.shade900,
    onTertiaryFixed: Colors.black,
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
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(
        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
    labelLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    labelSmall: TextStyle(color: Colors.blue),
    labelMedium: TextStyle(color: Colors.blue),
    titleMedium: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.blueGrey.shade900,
    labelTextStyle: const WidgetStatePropertyAll(
      TextStyle(color: Colors.white),
    ),
  ),
);
