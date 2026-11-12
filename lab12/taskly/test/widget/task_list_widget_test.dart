import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('Displays empty state message when there are no tasks', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Act
      final inputFinder = find.byKey(const Key('taskInputField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputFinder, 'Read Flutter Documentation');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert
      expect(find.text('Read Flutter Documentation'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      final inputFinder = find.byKey(const Key('taskInputField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      // Act: Add First Task
      await tester.enterText(inputFinder, 'Buy groceries');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Act: Add Second Task
      await tester.enterText(inputFinder, 'Write unit tests');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert
      expect(find.text('Buy groceries'), findsOneWidget);
      expect(find.text('Write unit tests'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });
  });
}

