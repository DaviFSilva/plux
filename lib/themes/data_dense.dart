// Plux — Data-dense / power-user direction.
//
// Dense, technical, all visible. Tight spacing, monospace numbers,
// table-style rows. Optimized for speed once learned.

import 'package:flutter/material.dart';

import '_builder.dart';

class DataDenseTokens extends Tokens {
  DataDenseTokens() : super(
    name: 'Data-dense',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0969DA),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFDBEAFE),
      onPrimaryContainer: Color(0xFF0C2A4D),
      secondary: Color(0xFF6B7280),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF3F4F6),
      onSecondaryContainer: Color(0xFF1F2937),
      tertiary: Color(0xFF059669),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFD1FAE5),
      onTertiaryContainer: Color(0xFF064E3B),
      error: Color(0xFFDC2626),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF111111),
      surfaceContainerHighest: Color(0xFFF9FAFB),
      onSurfaceVariant: Color(0xFF6B7280),
      outline: Color(0xFFE5E7EB),
      outlineVariant: Color(0xFFF3F4F6),
      inverseSurface: Color(0xFF111111),
      onInverseSurface: Color(0xFFFAFAFA),
      inversePrimary: Color(0xFF93C5FD),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFF0969DA),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF93C5FD),
      onPrimary: Color(0xFF0C2A4D),
      primaryContainer: Color(0xFF1E40AF),
      onPrimaryContainer: Color(0xFFDBEAFE),
      secondary: Color(0xFF9CA3AF),
      onSecondary: Color(0xFF1F2937),
      secondaryContainer: Color(0xFF1F2937),
      onSecondaryContainer: Color(0xFFE5E7EB),
      tertiary: Color(0xFF6EE7B7),
      onTertiary: Color(0xFF064E3B),
      tertiaryContainer: Color(0xFF065F46),
      onTertiaryContainer: Color(0xFFD1FAE5),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Color(0xFF0D1117),
      onSurface: Color(0xFFE6EDF3),
      surfaceContainerHighest: Color(0xFF161B22),
      onSurfaceVariant: Color(0xFF8B949E),
      outline: Color(0xFF30363D),
      outlineVariant: Color(0xFF21262D),
      inverseSurface: Color(0xFFE6EDF3),
      onInverseSurface: Color(0xFF0D1117),
      inversePrimary: Color(0xFF0969DA),
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFF93C5FD),
    ),
    radii: const ThemeRadii(sm: 2, md: 4, lg: 6),
    spacing: const ThemeSpacing(xs: 2, sm: 4, md: 8, lg: 12),
    typeScale: const TypeScale(
      displaySize: 22,
      titleSize: 13,
      bodySize: 12,
      labelSize: 11,
      displayWeight: FontWeight.w600,
      titleWeight: FontWeight.w500,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w500,
      titleCase: false,
    ),
  );

  static ThemeData lightTheme() => buildTheme(DataDenseTokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(DataDenseTokens(), Brightness.dark);
}