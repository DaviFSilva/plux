// Plux — Soft pastel / lo-fi direction.
//
// Friendly, low-pressure, slightly soft. Pastel pinks and mints, big
// rounded corners. Welcoming, not serious.

import 'package:flutter/material.dart';

import '_builder.dart';

class SoftPastelTokens extends Tokens {
  SoftPastelTokens() : super(
    name: 'Soft pastel',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE85D75),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFD9DF),
      onPrimaryContainer: Color(0xFF7F1D2E),
      secondary: Color(0xFF7FB7BE),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFD7ECEF),
      onSecondaryContainer: Color(0xFF1F4044),
      tertiary: Color(0xFFB5A0DC),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFE5DCF5),
      onTertiaryContainer: Color(0xFF3F2D6B),
      error: Color(0xFFD05E5E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF5D5D5),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Color(0xFFFFF8F0),
      onSurface: Color(0xFF3A3A3A),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF7F6F60),
      outline: Color(0xFFE5DACE),
      outlineVariant: Color(0xFFF0E8DC),
      inverseSurface: Color(0xFF3A3A3A),
      onInverseSurface: Color(0xFFFFF8F0),
      inversePrimary: Color(0xFFFFB5C2),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFFE85D75),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB5C2),
      onPrimary: Color(0xFF7F1D2E),
      primaryContainer: Color(0xFFB5394D),
      onPrimaryContainer: Color(0xFFFFD9DF),
      secondary: Color(0xFFA8DADC),
      onSecondary: Color(0xFF1F4044),
      secondaryContainer: Color(0xFF3F5A5E),
      onSecondaryContainer: Color(0xFFD7ECEF),
      tertiary: Color(0xFFD0BFE8),
      onTertiary: Color(0xFF3F2D6B),
      tertiaryContainer: Color(0xFF5B4880),
      onTertiaryContainer: Color(0xFFE5DCF5),
      error: Color(0xFFF5A5A5),
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFF5D5D5),
      surface: Color(0xFF1F1B17),
      onSurface: Color(0xFFEDE3D8),
      surfaceContainerHighest: Color(0xFF2A2520),
      onSurfaceVariant: Color(0xFFB8A78F),
      outline: Color(0xFF3D362E),
      outlineVariant: Color(0xFF2D2820),
      inverseSurface: Color(0xFFEDE3D8),
      onInverseSurface: Color(0xFF1F1B17),
      inversePrimary: Color(0xFFE85D75),
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFFFFB5C2),
    ),
    radii: const ThemeRadii(sm: 12, md: 20, lg: 28),
    spacing: const ThemeSpacing(xs: 8, sm: 12, md: 20, lg: 32),
    typeScale: const TypeScale(
      displaySize: 32,
      titleSize: 17,
      bodySize: 14,
      labelSize: 13,
      displayWeight: FontWeight.w600,
      titleWeight: FontWeight.w500,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w500,
      titleCase: false,
    ),
  );

  static ThemeData lightTheme() => buildTheme(SoftPastelTokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(SoftPastelTokens(), Brightness.dark);
}