// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab4/core_widgets_demo.dart';

void main() {
  testWidgets('CoreWidgetsDemo displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CoreWidgetsDemo()));

    expect(find.text('Exercise 1 – Core Widgets'), findsOneWidget);
    expect(find.text('Welcome to TOKYO'), findsOneWidget);
    expect(find.text('Movie Item'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
  });
}
