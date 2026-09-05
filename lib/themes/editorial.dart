// Plux — Editorial / magazine direction.
//
// Type-driven, content-first. Big headlines, narrow content column,
// generous margins. Serif-flavored through heavier weights + larger sizes.

import 'package:flutter/material.dart';

import '_builder.dart';

class EditorialTokens extends Tokens {
  EditorialTokens() : super(
    name: 'Editorial',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1A1A1A),
      onPrimary: Color(0xFFFAF7F2),
      primaryContainer: Color(0xFFE8E2D5),
      onPrimaryContainer: Color(0xFF1A1A1A),
      secondary: Color(0xFF6B5B47),
      onSecondary: Color(0xFFFAF7F2),
      secondaryContainer: Color(0xFFF0EBE0),
      onSecondaryContainer: Color(0xFF3D352A),
      tertiary: Color(0xFFB8492E),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFF5DDD3),
      onTertiaryContainer: Color(0xFF6B2814),
      error: Color(0xFFB91C1C),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFDE8E8),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Color(0xFFFAF7F2),
      onSurface: Color(0xFF1A1A1A),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF6B5B47),
      outline: Color(0xFFD4CFC5),
      outlineVariant: Color(0xFFE8E2D5),
      inverseSurface: Color(0xFF1A1A1A),
      onInverseSurface: Color(0xFFFAF7F2),
      inversePrimary: Color(0xFFE8E2D5),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFF1A1A1A),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE8E2D5),
      onPrimary: Color(0xFF1A1A1A),
      primaryContainer: Color(0xFF3D352A),
      onPrimaryContainer: Color(0xFFE8E2D5),
      secondary: Color(0xFFB8A78F),
      onSecondary: Color(0xFF1A1A1A),
      secondaryContainer: Color(0xFF52473D),
      onSecondaryContainer: Color(0xFFF0EBE0),
      tertiary: Color(0xFFE8A687),
      onTertiary: Color(0xFF1A1A1A),
      tertiaryContainer: Color(0xFF6B2814),
      onTertiaryContainer: Color(0xFFF5DDD3),
      error: Color(0xFFFCA5A5),
      onError: Color(0xFF1A1A1A),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFDE8E8),
      surface: Color(0xFF1A1714),
      onSurface: Color(0xFFEDE6DC),
      surfaceContainerHighest: Color(0xFF26221C),
      onSurfaceVariant: Color(0xFFB8A78F),
      outline: Color(0xFF3D362E),
      outlineVariant: Color(0xFF2D2A24),
      inverseSurface: Color(0xFFEDE6DC),
      onInverseSurface: Color(0xFF1A1714),
      inversePrimary: Color(0xFF1A1A1A),
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFFE8E2D5),
    ),
    radii: const ThemeRadii(sm: 2, md: 4, lg: 8),
    spacing: const ThemeSpacing(xs: 8, sm: 16, md: 28, lg: 48),
    typeScale: const TypeScale(
      displaySize: 44,
      titleSize: 22,
      bodySize: 16,
      labelSize: 13,
      displayWeight: FontWeight.w700,
      titleWeight: FontWeight.w600,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w600,
      titleCase: false,
    ),
  );

  static ThemeData lightTheme() => buildTheme(EditorialTokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(EditorialTokens(), Brightness.dark);
}