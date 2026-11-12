import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('Task Integration Tests (End-to-End Flow)', () {
    testWidgets('Full End-to-End lifecycle of a Task', (WidgetTester tester) async {
      final repository = TaskRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Verify empty state
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // Add "Original title"
      await tester.enterText(find.byKey(const Key('taskInputField')), 'Original title');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pumpAndSettle();

      expect(find.text('Original title'), findsOneWidget);

      // Navigate to detail
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      expect(find.text('Task Detail'), findsOneWidget);

      // Edit title to "Updated title"
      await tester.enterText(find.byKey(const Key('detailTitleField')), 'Updated title');

      // Save
      await tester.tap(find.byKey(const Key('saveTaskButton')));
      await tester.pumpAndSettle();

      // Verify updated title
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}

