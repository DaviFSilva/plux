// Plux — shared theme builder.
//
// Reads a direction's tokens (passed in as a TokenSet) and produces the
// ThemeData the template screen consumes. Each direction file in
// lib/themes/<direction>.dart defines its own TokenSet; this file is
// direction-agnostic.

import 'package:flutter/material.dart';

class Tokens {
  const Tokens({
    required this.name,
    required this.light,
    required this.dark,
    required this.radii,
    required this.spacing,
    required this.typeScale,
    this.useMonoFont = false,
    this.fontFamilyOverride,
  });

  final String name;
  final ColorScheme light;
  final ColorScheme dark;
  final ThemeRadii radii;
  final ThemeSpacing spacing;
  final TypeScale typeScale;
  final bool useMonoFont;
  /// If set, uses this font family instead of platform default or
  /// monospace. Must match the family name registered in web/index.html
  /// (Google Fonts link) before the Flutter app loads.
  final String? fontFamilyOverride;

  String? fontFamily() {
    if (fontFamilyOverride != null) return fontFamilyOverride;
    return useMonoFont ? 'monospace' : null;
  }

  TextTheme textTheme(Brightness brightness) =>
      typeScale.toTextTheme(brightness);
}

class ThemeRadii {
  const ThemeRadii({required this.sm, required this.md, required this.lg});
  final double sm;
  final double md;
  final double lg;
}

class ThemeSpacing {
  const ThemeSpacing({required this.xs, required this.sm, required this.md, required this.lg});
  final double xs;
  final double sm;
  final double md;
  final double lg;
}

class TypeScale {
  const TypeScale({
    required this.displaySize,
    required this.titleSize,
    required this.bodySize,
    required this.labelSize,
    required this.displayWeight,
    required this.titleWeight,
    required this.bodyWeight,
    required this.labelWeight,
    required this.titleCase,
  });

  final double displaySize;
  final double titleSize;
  final double bodySize;
  final double labelSize;
  final FontWeight displayWeight;
  final FontWeight titleWeight;
  final FontWeight bodyWeight;
  final FontWeight labelWeight;

  /// `TitleCase` means "DECKS" with letter-spacing. `Sentence case` is
  /// "Decks" without. Used by section headers.
  final bool titleCase;

  TextTheme toTextTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    final displayColor = brightness == Brightness.dark
        ? const Color(0xFFE5E5E5)
        : const Color(0xFF111111);
    final bodyColor = brightness == Brightness.dark
        ? const Color(0xFFD4D4D4)
        : const Color(0xFF1A1A1A);

    return base.copyWith(
      displaySmall: TextStyle(
        fontSize: displaySize,
        fontWeight: displayWeight,
        color: displayColor,
        height: 1.1,
        letterSpacing: displayWeight == FontWeight.w700 ? -0.5 : 0,
      ),
      titleLarge: TextStyle(
        fontSize: titleSize + 2,
        fontWeight: titleWeight,
        color: displayColor,
      ),
      titleMedium: TextStyle(
        fontSize: titleSize,
        fontWeight: titleWeight,
        color: displayColor,
      ),
      bodyLarge: TextStyle(
        fontSize: bodySize + 1,
        fontWeight: bodyWeight,
        color: bodyColor,
      ),
      bodyMedium: TextStyle(
        fontSize: bodySize,
        fontWeight: bodyWeight,
        color: bodyColor,
      ),
      bodySmall: TextStyle(
        fontSize: bodySize - 1,
        fontWeight: bodyWeight,
        color: bodyColor,
      ),
      labelLarge: TextStyle(
        fontSize: labelSize,
        fontWeight: labelWeight,
        color: bodyColor,
        letterSpacing: titleCase ? 1.4 : 0,
      ),
    );
  }
}

ThemeData buildTheme(Tokens t, Brightness brightness) {
  final scheme = brightness == Brightness.light ? t.light : t.dark;
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    canvasColor: scheme.surface,
    fontFamily: t.fontFamily(),
    textTheme: t.textTheme(brightness),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: isDark ? 0 : 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: t.typeScale.titleSize,
        fontWeight: FontWeight.w600,
        fontFamily: t.fontFamily(),
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHighest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.radii.md),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      textColor: scheme.onSurface,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.lg,
          vertical: t.spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radii.md),
        ),
        textStyle: TextStyle(
          fontSize: t.typeScale.bodySize + 1,
          fontWeight: FontWeight.w600,
          fontFamily: t.fontFamily(),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.lg,
          vertical: t.spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radii.md),
        ),
        side: BorderSide(color: scheme.outline, width: t.useMonoFont ? 1 : 1),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.secondaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: t.typeScale.labelSize,
          color: scheme.onSurface,
          fontFamily: t.fontFamily(),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 0.5,
      space: 0.5,
    ),
  );
}