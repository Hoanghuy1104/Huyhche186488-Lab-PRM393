import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('Task Integration Tests (Full User Flow)', () {
    testWidgets('Full flow: Add "Original title" -> Open detail -> Edit to "Updated title" -> Save -> Verify in list',
        (WidgetTester tester) async {
      // 1. Arrange & Pump App with an empty repository
      final repository = TaskRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Verify empty state is displayed initially
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // 2. Add "Original title"
      final inputFinder = find.byKey(const Key('taskInputField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputFinder, 'Original title');
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      // Verify "Original title" appears in list
      expect(find.text('Original title'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);

      // 3. Tap task -> open detail screen
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Verify detail screen is displayed
      expect(find.text('Task Detail'), findsOneWidget);
      final detailFieldFinder = find.byKey(const Key('detailTitleField'));
      expect(detailFieldFinder, findsOneWidget);

      // 4. Edit -> "Updated title"
      await tester.enterText(detailFieldFinder, 'Updated title');

      // 5. Tap Save
      final saveButtonFinder = find.byKey(const Key('saveTaskButton'));
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // 6. Verify back on TaskListScreen with "Updated title"
      expect(find.text('Task Detail'), findsNothing);
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}

