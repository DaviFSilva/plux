import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plux/main.dart';

void main() {
  testWidgets('Template screen renders visible sections on first frame',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PluxApp());
    await tester.pumpAndSettle();

    // App bar shows the theme label
    expect(find.textContaining('Plux'), findsOneWidget);

    // Greeting + subtitle (above the fold)
    expect(find.text('Good evening, Davi'), findsOneWidget);

    // Section header visible at top of body
    expect(find.text('DECKS'), findsOneWidget);

    // Decks
    expect(find.text('Spanish vocab'), findsOneWidget);
    expect(find.text('Capital cities'), findsOneWidget);
    expect(find.text('Rust ownership'), findsOneWidget);

    // Bottom nav
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Decks'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Toggling theme rebuilds with dark mode', (tester) async {
    await tester.pumpWidget(const PluxApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.brightness_6_outlined), findsOneWidget);

    final toggle = find.byIcon(Icons.brightness_6_outlined);
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });

  group('resolveThemes', () {
    for (final entry in const <String, String>{
      'material3': 'Material 3',
      'premium-minimal': 'Premium minimal',
      'premium_minimal': 'Premium minimal',
      'warm-journal': 'Warm journal',
      'brutalist': 'Brutalist',
      'editorial': 'Editorial',
      'data-dense': 'Data-dense',
      'data_dense': 'Data-dense',
      'soft-pastel': 'Soft pastel',
      'terminal': 'Terminal',
      '': 'Material 3',
      'unknown-thing': 'Material 3',
    }.entries) {
      test('"${entry.key}" -> ${entry.value}', () {
        final result = PluxApp.resolveThemes(entry.key);
        expect(result.label, entry.value);
        expect(result.light, isA<ThemeData>());
        expect(result.dark, isA<ThemeData>());
      });
    }
  });
}