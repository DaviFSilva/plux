import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plux/main.dart';

void main() {
  testWidgets('Plux home screen renders title and feature chips',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PluxApp());
    await tester.pumpAndSettle();

    expect(find.text('Plux'), findsWidgets);
    expect(find.byIcon(Icons.school_outlined), findsOneWidget);
    expect(find.text('Spaced-repetition flashcards'), findsOneWidget);
  });
}