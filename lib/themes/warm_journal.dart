// Plux — Warm journal direction (Things / Bear / Day One school).
//
// Soft warm grays, generous whitespace, paper-like. Calm. Slower
// interactions. Good for journal and knowledge sections.

import 'package:flutter/material.dart';

import '_builder.dart';

class WarmJournalTokens extends Tokens {
  WarmJournalTokens() : super(
    name: 'Warm journal',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFB85C38),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFF5E6DD),
      onPrimaryContainer: Color(0xFF6B2814),
      secondary: Color(0xFF8B7355),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF0E8DD),
      onSecondaryContainer: Color(0xFF3D2F22),
      tertiary: Color(0xFF5B7C5B),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFE0EADD),
      onTertiaryContainer: Color(0xFF2D3D2D),
      error: Color(0xFFB91C1C),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFDE8E8),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Color(0xFFFAF8F5),
      onSurface: Color(0xFF2D2A26),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF6B635A),
      outline: Color(0xFFD4CFC7),
      outlineVariant: Color(0xFFE8E3DA),
      inverseSurface: Color(0xFF2D2A26),
      onInverseSurface: Color(0xFFFAF8F5),
      inversePrimary: Color(0xFFE8A687),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFFB85C38),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE8A687),
      onPrimary: Color(0xFF6B2814),
      primaryContainer: Color(0xFF8B3F25),
      onPrimaryContainer: Color(0xFFF5E6DD),
      secondary: Color(0xFFB8A78F),
      onSecondary: Color(0xFF3D2F22),
      secondaryContainer: Color(0xFF52473D),
      onSecondaryContainer: Color(0xFFF0E8DD),
      tertiary: Color(0xFF9CB59C),
      onTertiary: Color(0xFF2D3D2D),
      tertiaryContainer: Color(0xFF3F5A3F),
      onTertiaryContainer: Color(0xFFE0EADD),
      error: Color(0xFFFCA5A5),
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFDE8E8),
      surface: Color(0xFF1C1A17),
      onSurface: Color(0xFFEDE6DC),
      surfaceContainerHighest: Color(0xFF26241F),
      onSurfaceVariant: Color(0xFFB8A78F),
      outline: Color(0xFF3D362E),
      outlineVariant: Color(0xFF2D2A24),
      inverseSurface: Color(0xFFEDE6DC),
      onInverseSurface: Color(0xFF1C1A17),
      inversePrimary: Color(0xFFB85C38),
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFFE8A687),
    ),
    radii: const ThemeRadii(sm: 6, md: 10, lg: 14),
    spacing: const ThemeSpacing(xs: 6, sm: 12, md: 20, lg: 32),
    typeScale: const TypeScale(
      displaySize: 34,
      titleSize: 17,
      bodySize: 15,
      labelSize: 12,
      displayWeight: FontWeight.w500,
      titleWeight: FontWeight.w500,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w500,
      titleCase: false,
    ),
  );

  static ThemeData lightTheme() => buildTheme(WarmJournalTokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(WarmJournalTokens(), Brightness.dark);
}