// Plux — Visual direction tokens.
//
// The committed direction. See docs/plux-direction.md for rationale.
//
// Open questions answered here (defer-to-default choices):
// 1. Metaball filter scope: nav indicator + active filter chips only.
//    Cards/buttons get animated border-radius, no metaball. Keeps the
//    signature effect readable, not gimmicky.
// 2. Loading animations: skeleton placeholders for content; the
//    "breathing border-radius" for the active nav indicator only.
// 3. Dark mode weight: equal. Both modes get full treatment.

import 'package:flutter/material.dart';

import '_builder.dart';

class PluxTokens extends Tokens {
  PluxTokens() : super(
    name: 'Plux',
    light: _lightScheme,
    dark: _darkScheme,
    radii: const ThemeRadii(sm: 12, md: 20, lg: 32),
    spacing: const ThemeSpacing(xs: 6, sm: 12, md: 20, lg: 28),
    typeScale: const TypeScale(
      displaySize: 32,
      titleSize: 18,
      bodySize: 14,
      labelSize: 12,
      displayWeight: FontWeight.w500,
      titleWeight: FontWeight.w500,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w500,
      titleCase: false,
    ),
    // Fonts are loaded via web/index.html <link> to Google Fonts.
    // The family name below is what Flutter uses to resolve the font.
    fontFamilyOverride: 'Ubuntu',
  );

  static ThemeData lightTheme() => buildTheme(PluxTokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(PluxTokens(), Brightness.dark);

  // Violet tonal palette generated from seed #7C3AED.
  // Both schemes use Material 3 ColorScheme.fromSeed to ensure tonal
  // consistency (primary container, on-primary, etc. all derive from
  // the same hue).
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF7C3AED),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEDE4FE),
    onPrimaryContainer: Color(0xFF2A0F6E),
    secondary: Color(0xFF8B5CF6),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF3EBFE),
    onSecondaryContainer: Color(0xFF311773),
    tertiary: Color(0xFF6D28D9),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE9DDFD),
    onTertiaryContainer: Color(0xFF220A56),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Color(0xFFFBFAFE),
    onSurface: Color(0xFF1A1525),
    surfaceContainerHighest: Color(0xFFF4F1FB),
    onSurfaceVariant: Color(0xFF635B72),
    outline: Color(0xFFDDD5EC),
    outlineVariant: Color(0xFFE8E2F4),
    inverseSurface: Color(0xFF1A1525),
    onInverseSurface: Color(0xFFFBFAFE),
    inversePrimary: Color(0xFFB89DFC),
    shadow: Color(0xFF000000),
    scrim: Color(0x66000000),
    surfaceTint: Color(0xFF7C3AED),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB89DFC),
    onPrimary: Color(0xFF2A0F6E),
    primaryContainer: Color(0xFF4B22A8),
    onPrimaryContainer: Color(0xFFEDE4FE),
    secondary: Color(0xFFCBADFF),
    onSecondary: Color(0xFF311773),
    secondaryContainer: Color(0xFF5B3AAA),
    onSecondaryContainer: Color(0xFFF3EBFE),
    tertiary: Color(0xFFB89DFC),
    onTertiary: Color(0xFF220A56),
    tertiaryContainer: Color(0xFF4B22A8),
    onTertiaryContainer: Color(0xFFE9DDFD),
    error: Color(0xFFFC9292),
    onError: Color(0xFF7F1D1D),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: Color(0xFF13101D),
    onSurface: Color(0xFFEDE8F7),
    surfaceContainerHighest: Color(0xFF1F1A2E),
    onSurfaceVariant: Color(0xFFB6AECF),
    outline: Color(0xFF3D354F),
    outlineVariant: Color(0xFF2A2438),
    inverseSurface: Color(0xFFEDE8F7),
    onInverseSurface: Color(0xFF13101D),
    inversePrimary: Color(0xFF7C3AED),
    shadow: Color(0xFF000000),
    scrim: Color(0x99000000),
    surfaceTint: Color(0xFFB89DFC),
  );
}