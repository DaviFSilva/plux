// Plux — entry point.
//
// For now, this serves the template screen (see docs/template-screen.md)
// or the stress-test screen for the committed Plux direction
// (see docs/plux-direction.md). URL query param `?theme=<name>`
// selects a direction; default is `material3`.
//
// Available themes: material3, premium-minimal, warm-journal, brutalist,
// editorial, data-dense, soft-pastel, terminal, plux.
//
// Once a single direction is committed, this file becomes the real
// Plux home screen and the theme switcher goes away.

import 'package:flutter/material.dart';
import 'package:plux/screens/stress_test/stress_test_screen.dart';
import 'package:plux/screens/template_screen.dart';
import 'package:plux/themes/material3.dart';
import 'package:plux/themes/plux.dart';
import 'package:plux/themes/premium_minimal.dart';
import 'package:plux/themes/warm_journal.dart';
import 'package:plux/themes/brutalist.dart';
import 'package:plux/themes/editorial.dart';
import 'package:plux/themes/data_dense.dart';
import 'package:plux/themes/soft_pastel.dart';
import 'package:plux/themes/terminal.dart';

void main() {
  runApp(const PluxApp());
}

class PluxApp extends StatefulWidget {
  const PluxApp({super.key});

  @override
  State<PluxApp> createState() => _PluxAppState();

  /// Resolve the active theme pair from a URL `?theme=<name>` value.
  /// Defaults to material3 when the param is missing or unknown.
  /// Public so tests can exercise the resolver without faking `Uri.base`.
  static ({ThemeData light, ThemeData dark, String label}) resolveThemes(
      String? requested) {
    final name = (requested ?? 'material3').toLowerCase();

    switch (name) {
      case 'premium-minimal':
      case 'premium_minimal':
        return (
          light: PremiumMinimalTokens.lightTheme(),
          dark: PremiumMinimalTokens.darkTheme(),
          label: 'Premium minimal',
        );
      case 'plux':
        return (
          light: PluxTokens.lightTheme(),
          dark: PluxTokens.darkTheme(),
          label: 'Plux (committed)',
        );
      case 'warm-journal':
      case 'warm_journal':
        return (
          light: WarmJournalTokens.lightTheme(),
          dark: WarmJournalTokens.darkTheme(),
          label: 'Warm journal',
        );
      case 'brutalist':
        return (
          light: BrutalistTokens.lightTheme(),
          dark: BrutalistTokens.darkTheme(),
          label: 'Brutalist',
        );
      case 'editorial':
        return (
          light: EditorialTokens.lightTheme(),
          dark: EditorialTokens.darkTheme(),
          label: 'Editorial',
        );
      case 'data-dense':
      case 'data_dense':
        return (
          light: DataDenseTokens.lightTheme(),
          dark: DataDenseTokens.darkTheme(),
          label: 'Data-dense',
        );
      case 'soft-pastel':
      case 'soft_pastel':
        return (
          light: SoftPastelTokens.lightTheme(),
          dark: SoftPastelTokens.darkTheme(),
          label: 'Soft pastel',
        );
      case 'terminal':
        return (
          light: TerminalTokens.lightTheme(),
          dark: TerminalTokens.darkTheme(),
          label: 'Terminal',
        );
      case 'material3':
      default:
        return (
          light: Material3Tokens.lightTheme(),
          dark: Material3Tokens.darkTheme(),
          label: 'Material 3',
        );
    }
  }
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
    final themes = PluxApp.resolveThemes(Uri.base.queryParameters['theme']);

    return MaterialApp(
      title: 'Plux template',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: themes.light,
      darkTheme: themes.dark,
      home: _buildHome(themes.label),
    );
  }

  /// The Plux direction uses the full stress-test screen so the liquid
  /// interactions have real components to bend. Other directions keep
  /// the simpler template screen.
  Widget _buildHome(String label) {
    if (label == 'Plux (committed)') {
      return StressTestScreen(
        isDark: _isDark,
        toggleTheme: _toggleTheme,
      );
    }
    return TemplateScreen(
      toggleTheme: _toggleTheme,
      isDark: _isDark,
      themeLabel: label,
    );
  }
}