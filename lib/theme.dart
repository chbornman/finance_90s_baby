import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      primary: Colors.blue,
      secondary: Colors.green,
      surface: Colors.white,
      onSurface: Colors.black),
  useMaterial3: true,
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
);
