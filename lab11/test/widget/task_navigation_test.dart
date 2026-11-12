import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('Task Navigation Tests (TaskList -> TaskDetail)', () {
    testWidgets('Tapping a seeded task navigates to TaskDetailScreen with correct elements', (WidgetTester tester) async {
      // Arrange: Seed repository with at least one task
      final repository = TaskRepository();
      final seededTask = Task(id: 'seeded_1', title: 'Prepare Presentation');
      repository.addTask(seededTask);

      // Pump TaskListScreen
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Verify seeded task is present
      expect(find.text('Prepare Presentation'), findsOneWidget);

      // Act: Tap seeded task -> call pumpAndSettle()
      await tester.tap(find.text('Prepare Presentation'));
      await tester.pumpAndSettle();

      // Validate: AppBar title is "Task Detail"
      expect(find.text('Task Detail'), findsOneWidget);

      // Validate: TextField key detailTitleField exists and contains seeded title
      final detailTitleFieldFinder = find.byKey(const Key('detailTitleField'));
      expect(detailTitleFieldFinder, findsOneWidget);

      final TextField titleTextField = tester.widget<TextField>(detailTitleFieldFinder);
      expect(titleTextField.controller?.text, equals('Prepare Presentation'));
    });
  });
}

