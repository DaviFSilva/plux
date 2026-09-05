// Plux — Brutalist / neobrutalist direction.
//
// Raw, intentional, anti-slick. Heavy borders, sharp corners, high
// contrast. Black-on-white. Visibly structured.

import 'package:flutter/material.dart';

import '_builder.dart';

class BrutalistTokens extends Tokens {
  BrutalistTokens() : super(
    name: 'Brutalist',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFEB3B),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFF000000),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE5E5E5),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFFF5722),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFE0D6),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFE53935),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFE5E5),
      onErrorContainer: Color(0xFF000000),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF000000),
      outline: Color(0xFF000000),
      outlineVariant: Color(0xFF000000),
      inverseSurface: Color(0xFF000000),
      onInverseSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFFFFFFFF),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFF000000),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFFFFEB3B),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF1A1A1A),
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFFFF7043),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF3F1E14),
      onTertiaryContainer: Color(0xFFFFE0D6),
      error: Color(0xFFFF5252),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF3F0A0A),
      onErrorContainer: Color(0xFFFFE5E5),
      surface: Color(0xFF000000),
      onSurface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFF0D0D0D),
      onSurfaceVariant: Color(0xFFFFFFFF),
      outline: Color(0xFFFFFFFF),
      outlineVariant: Color(0xFFFFFFFF),
      inverseSurface: Color(0xFFFFFFFF),
      onInverseSurface: Color(0xFF000000),
      inversePrimary: Color(0xFF000000),
      shadow: Color(0xFFFFFFFF),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFFFFFFFF),
    ),
    radii: const ThemeRadii(sm: 0, md: 0, lg: 0),
    spacing: const ThemeSpacing(xs: 4, sm: 8, md: 12, lg: 16),
    typeScale: const TypeScale(
      displaySize: 36,
      titleSize: 16,
      bodySize: 14,
      labelSize: 12,
      displayWeight: FontWeight.w900,
      titleWeight: FontWeight.w700,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w700,
      titleCase: true,
    ),
  );

  static ThemeData lightTheme() {
    final tokens = BrutalistTokens();
    final base = buildTheme(tokens, Brightness.light);
    return base.copyWith(
      cardTheme: CardThemeData(
        color: base.colorScheme.surfaceContainerHighest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radii.md),
          side: BorderSide(color: base.colorScheme.outline, width: 2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: base.colorScheme.outline, width: 2),
          ),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: tokens.spacing.lg,
              vertical: tokens.spacing.md,
            ),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: base.colorScheme.outline,
        thickness: 1.5,
        space: 1,
      ),
    );
  }

  static ThemeData darkTheme() {
    final tokens = BrutalistTokens();
    final base = buildTheme(tokens, Brightness.dark);
    return base.copyWith(
      cardTheme: CardThemeData(
        color: base.colorScheme.surfaceContainerHighest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radii.md),
          side: BorderSide(color: base.colorScheme.outline, width: 2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: base.colorScheme.outline, width: 2),
          ),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: tokens.spacing.lg,
              vertical: tokens.spacing.md,
            ),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: base.colorScheme.outline,
        thickness: 1.5,
        space: 1,
      ),
    );
  }
}