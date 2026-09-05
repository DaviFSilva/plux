// Plux — entry point.
//
// For now, this serves the template screen (see docs/template-screen.md)
// so we can compare design directions side by side. Once a direction is
// picked, this file becomes the real Plux home screen.

import 'package:flutter/material.dart';
import 'package:plux/screens/template_screen.dart';
import 'package:plux/themes/material3.dart';

void main() {
  runApp(const PluxApp());
}

class PluxApp extends StatefulWidget {
  const PluxApp({super.key});

  @override
  State<PluxApp> createState() => _PluxAppState();
}

class _PluxAppState extends State<PluxApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  bool get _isDark => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plux template',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: PluxTheme.light(),
      darkTheme: PluxTheme.dark(),
      home: TemplateScreen(
        toggleTheme: _toggleTheme,
        isDark: _isDark,
      ),
    );
  }
}