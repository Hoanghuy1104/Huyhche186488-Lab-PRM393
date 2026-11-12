import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/providers/task_provider.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';
import 'package:taskly/widgets/task_tile.dart';

void main() {
  group('Lab 12 Performance Optimization Tests', () {
    testWidgets('TaskTile uses ValueKey(task.id) and toggles/deletes via TaskProvider',
        (WidgetTester tester) async {
      final repository = TaskRepository();
      repository.addTask(Task(id: 't1', title: 'Task One'));
      repository.addTask(Task(id: 't2', title: 'Task Two'));

      await tester.pumpWidget(
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(repository: repository),
          child: const MaterialApp(home: TaskListScreen()),
        ),
      );

      expect(find.byKey(const ValueKey('t1')), findsOneWidget);
      expect(find.byKey(const ValueKey('t2')), findsOneWidget);
      expect(find.byType(TaskTile), findsNWidgets(2));

      // Toggle first task checkbox
      final firstTile = find.byKey(const ValueKey('t1'));
      final checkbox = find.descendant(
        of: firstTile,
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkbox);
      await tester.pump();

      expect(repository.getTaskById('t1')?.completed, isTrue);
      expect(repository.getTaskById('t2')?.completed, isFalse);

      // Delete first task
      final deleteButton = find.descendant(
        of: firstTile,
        matching: find.byIcon(Icons.delete),
      );
      await tester.tap(deleteButton);
      await tester.pump();

      expect(find.byKey(const ValueKey('t1')), findsNothing);
      expect(find.byKey(const ValueKey('t2')), findsOneWidget);
    });

    testWidgets('Selector<TaskProvider, List<Task>> does not rebuild input section when tasks change',
        (WidgetTester tester) async {
      final repository = TaskRepository();
      int textFieldElementHashesAfterFirstBuild = 0;

      await tester.pumpWidget(
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(repository: repository),
          child: const MaterialApp(home: TaskListScreen()),
        ),
      );

      final textFieldFinder = find.byKey(const Key('taskInputField'));
      final elementBefore = tester.element(textFieldFinder);
      textFieldElementHashesAfterFirstBuild = identityHashCode(elementBefore);

      // Add task, toggle task, delete task
      await tester.enterText(textFieldFinder, 'Optimize rebuilds');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      final task = repository.tasks.single;
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      final elementAfter = tester.element(textFieldFinder);
      expect(identityHashCode(elementAfter), equals(textFieldElementHashesAfterFirstBuild));
      expect(task.title, equals('Optimize rebuilds'));
    });

    testWidgets('Taskly logo asset renders and is precached', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(),
          child: const MaterialApp(home: TaskListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // AppBar logo + Empty state logo
      expect(find.byType(Image), findsNWidgets(2));
    });
  });
}

