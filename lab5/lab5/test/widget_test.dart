// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:lab5/main.dart';

Future<void> main() async {
  testWidgets('Movie app shows movie list and detail screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieApp());

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsOneWidget);

    await tester.tap(find.text('Dune: Part Two'));
    await tester.pumpAndSettle();

    expect(find.text('Trailers'), findsOneWidget);
    expect(find.text('Official Trailer #1'), findsOneWidget);
  });
}
