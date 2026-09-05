// Plux — Material 3 direction (baseline).
//
// Tonal palette generated from indigo seed. System fonts. Light + dark.
// Generic, friendly, predictable. Use as the default; not the answer.

import 'package:flutter/material.dart';

import '_builder.dart';

class Material3Tokens extends Tokens {
  Material3Tokens() : super(
    name: 'Material 3',
    light: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: Brightness.light,
    ),
    dark: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: Brightness.dark,
    ),
    radii: const ThemeRadii(sm: 8, md: 12, lg: 16),
    spacing: const ThemeSpacing(xs: 4, sm: 8, md: 16, lg: 24),
    typeScale: const TypeScale(
      displaySize: 32,
      titleSize: 18,
      bodySize: 14,
      labelSize: 12,
      displayWeight: FontWeight.w600,
      titleWeight: FontWeight.w600,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w600,
      titleCase: true,
    ),
  );

  static ThemeData lightTheme() => buildTheme(Material3Tokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(Material3Tokens(), Brightness.dark);
}