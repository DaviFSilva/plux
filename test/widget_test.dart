import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plux/main.dart';

void main() {
  testWidgets('Template screen renders visible sections on first frame',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PluxApp());
    await tester.pumpAndSettle();

    // App bar
    expect(find.text('Plux template'), findsOneWidget);

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

  testWidgets('Scrolling reveals quick-add, activity, review, empty state',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PluxApp());
    await tester.pumpAndSettle();

    // Scroll the ListView to bring lower sections into the lazy-built area
    await tester.scrollUntilVisible(
      find.text('QUICK ADD'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('QUICK ADD'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('RECENT ACTIVITY'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('RECENT ACTIVITY'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Start review'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Start review'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('No decks yet'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('No decks yet'), findsOneWidget);
  });

  testWidgets('Toggling theme rebuilds with dark mode', (tester) async {
    await tester.pumpWidget(const PluxApp());
    await tester.pumpAndSettle();

    // Light mode: brightness_6 icon
    expect(find.byIcon(Icons.brightness_6_outlined), findsOneWidget);

    final toggle = find.byIcon(Icons.brightness_6_outlined);
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    // Dark mode: light_mode icon
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });
}