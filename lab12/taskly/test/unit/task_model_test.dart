import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Default completed value should be false (AAA pattern)', () {
      // Arrange
      const String taskId = 'task_1';
      const String taskTitle = 'Finish PRM393 Lab 11';

      // Act
      final task = Task(id: taskId, title: taskTitle);

      // Assert
      expect(task.id, equals(taskId));
      expect(task.title, equals(taskTitle));
      expect(task.completed, isFalse);
    });

    test('toggle() should switch completed state true <-> false (AAA pattern)', () {
      // Arrange
      final task = Task(id: 'task_2', title: 'Test toggle method');
      expect(task.completed, isFalse);

      // Act 1: Toggle from false to true
      task.toggle();

      // Assert 1
      expect(task.completed, isTrue);

      // Act 2: Toggle from true back to false
      task.toggle();

      // Assert 2
      expect(task.completed, isFalse);
    });

    test('copyWith() should create a copy with updated fields (AAA pattern)', () {
      // Arrange
      final initialTask = Task(id: 'task_3', title: 'Old Title', completed: false);

      // Act
      final updatedTask = initialTask.copyWith(
        title: 'New Title',
        completed: true,
      );

      // Assert
      expect(updatedTask.id, equals('task_3'));
      expect(updatedTask.title, equals('New Title'));
      expect(updatedTask.completed, isTrue);
      // Ensure immutability / original is untouched
      expect(initialTask.title, equals('Old Title'));
      expect(initialTask.completed, isFalse);
    });
  });
}

