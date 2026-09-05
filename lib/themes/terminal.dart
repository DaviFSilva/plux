// Plux — Terminal / mono-everything direction.
//
// Hacker aesthetic. Monospace everywhere, ASCII-friendly layout,
// green-on-black or amber-on-black.

import 'package:flutter/material.dart';

import '_builder.dart';

class TerminalTokens extends Tokens {
  TerminalTokens() : super(
    name: 'Terminal',
    light: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF008000),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFC8E6C9),
      onPrimaryContainer: Color(0xFF1B5E20),
      secondary: Color(0xFF606060),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE0E0E0),
      onSecondaryContainer: Color(0xFF1A1A1A),
      tertiary: Color(0xFFB8860B),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFFF3C4),
      onTertiaryContainer: Color(0xFF604A00),
      error: Color(0xFFCC0000),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF5C5C5),
      onErrorContainer: Color(0xFF660000),
      surface: Color(0xFFF5F5F5),
      onSurface: Color(0xFF1A1A1A),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF606060),
      outline: Color(0xFFBDBDBD),
      outlineVariant: Color(0xFFE0E0E0),
      inverseSurface: Color(0xFF000000),
      onInverseSurface: Color(0xFFE0E0E0),
      inversePrimary: Color(0xFF4CAF50),
      shadow: Color(0xFF000000),
      scrim: Color(0x66000000),
      surfaceTint: Color(0xFF008000),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF00FF00),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF003F00),
      onPrimaryContainer: Color(0xFF00FF00),
      secondary: Color(0xFFB0B0B0),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF1A1A1A),
      onSecondaryContainer: Color(0xFFE0E0E0),
      tertiary: Color(0xFFFFB000),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF604A00),
      onTertiaryContainer: Color(0xFFFFD980),
      error: Color(0xFFFF5555),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF660000),
      onErrorContainer: Color(0xFFFFC5C5),
      surface: Color(0xFF000000),
      onSurface: Color(0xFF00FF00),
      surfaceContainerHighest: Color(0xFF0A0A0A),
      onSurfaceVariant: Color(0xFF80FF80),
      outline: Color(0xFF00AA00),
      outlineVariant: Color(0xFF005500),
      inverseSurface: Color(0xFF00FF00),
      onInverseSurface: Color(0xFF000000),
      inversePrimary: Color(0xFF008000),
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
      surfaceTint: Color(0xFF00FF00),
    ),
    radii: const ThemeRadii(sm: 0, md: 0, lg: 0),
    spacing: const ThemeSpacing(xs: 4, sm: 6, md: 10, lg: 16),
    typeScale: const TypeScale(
      displaySize: 24,
      titleSize: 14,
      bodySize: 13,
      labelSize: 12,
      displayWeight: FontWeight.w500,
      titleWeight: FontWeight.w500,
      bodyWeight: FontWeight.w400,
      labelWeight: FontWeight.w500,
      titleCase: false,
    ),
    useMonoFont: true,
  );

  static ThemeData lightTheme() {
    final tokens = TerminalTokens();
    final base = buildTheme(tokens, Brightness.light);
    return base.copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: base.colorScheme.outline, width: 1),
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
    );
  }

  static ThemeData darkTheme() {
    final tokens = TerminalTokens();
    final base = buildTheme(tokens, Brightness.dark);
    return base.copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: base.colorScheme.outline, width: 1),
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
    );
  }
}