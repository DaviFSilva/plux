// Plux — Premium minimal direction (Linear / Vercel school).
//
// Dark, restrained, considered. Quiet chrome, content-forward.
// Heavy on negative space, single bright accent, subtle borders.

import 'package:flutter/material.dart';

import '_builder.dart';

class PremiumMinimalTokens extends Tokens {
  PremiumMinimalTokens() : super(
    name: 'Premium minimal',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF5B4FE9),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFEDEBFC),
      onPrimaryContainer: Color(0xFF1F1A6E),
      secondary: Color(0xFF6B7280),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF3F4F6),
      onSecondaryContainer: Color(0xFF1F2937),
      tertiary: Color(0xFFEAB308),
      onTertiary: Color(0xFF1A1300),
      tertiaryContainer: Color(0xFFFEF3C7),
      onTertiaryContainer: Color(0xFF422006),
      error: Color(0xFFDC2626),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Color(0xFFFAFAFA),
      onSurface: Color(0xFF0A0A0A),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF6B7280),
      outline: Color(0xFFE5E5E5),
      outlineVariant: Color(0xFFF3F4F6),
      inverseSurface: Color(0xFF0A0A0A),
      onInverseSurface: Color(0xFFFAFAFA),
      inversePrimary: Color(0xFFA5B4FC),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFF5B4FE9),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA5B4FC),
      onPrimary: Color(0xFF1E1B4B),
      primaryContainer: Color(0xFF312E81),
      onPrimaryContainer: Color(0xFFEDEBFC),
      secondary: Color(0xFF9CA3AF),
      onSecondary: Color(0xFF1F2937),
      secondaryContainer: Color(0xFF1F2937),
      onSecondaryContainer: Color(0xFFE5E7EB),
      tertiary: Color(0xFFFCD34D),
      onTertiary: Color(0xFF422006),
      tertiaryContainer: Color(0xFF713F12),
      onTertiaryContainer: Color(0xFFFEF3C7),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Color(0xFF0A0A0A),
      onSurface: Color(0xFFE5E5E5),
      surfaceContainerHighest: Color(0xFF171717),
      onSurfaceVariant: Color(0xFF9CA3AF),
      outline: Color(0xFF262626),
      outlineVariant: Color(0xFF1F1F1F),
      inverseSurface: Color(0xFFE5E5E5),
      onInverseSurface: Color(0xFF0A0A0A),
      inversePrimary: Color(0xFF5B4FE9),
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFFA5B4FC),
    ),
    radii: const ThemeRadii(sm: 4, md: 6, lg: 8),
    spacing: const ThemeSpacing(xs: 4, sm: 8, md: 16, lg: 24),
    typeScale: const TypeScale(
      displaySize: 30,
      titleSize: 15,
      bodySize: 14,
      labelSize: 12,
      displayWeight: FontWeight.w600,
      titleWeight: FontWeight.w500,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w500,
      titleCase: false,
    ),
  );

  static ThemeData lightTheme() => buildTheme(PremiumMinimalTokens(), Brightness.light);
  static ThemeData darkTheme() => buildTheme(PremiumMinimalTokens(), Brightness.dark);
}