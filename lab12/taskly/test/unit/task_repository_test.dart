import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() should add a new task to repository (AAA pattern)', () {
      // Arrange
      final task = Task(id: '1', title: 'Task 1');
      expect(repository.tasks.isEmpty, isTrue);

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.id, equals('1'));
      expect(repository.tasks.first.title, equals('Task 1'));
      expect(repository.tasks.contains(task), isTrue);
    });

    test('deleteTask() should remove task by id (AAA pattern)', () {
      // Arrange
      final task1 = Task(id: '1', title: 'Task 1');
      final task2 = Task(id: '2', title: 'Task 2');
      repository.addTask(task1);
      repository.addTask(task2);
      expect(repository.tasks.length, equals(2));

      // Act
      repository.deleteTask('1');

      // Assert
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.any((t) => t.id == '1'), isFalse);
      expect(repository.tasks.first.id, equals('2'));
    });

    test('updateTask() should update an existing task (AAA pattern)', () {
      // Arrange
      final initialTask = Task(id: '1', title: 'Initial Title', completed: false);
      repository.addTask(initialTask);

      final updatedTask = Task(id: '1', title: 'Updated Title', completed: true);

      // Act
      repository.updateTask(updatedTask);

      // Assert
      expect(repository.tasks.length, equals(1));
      final taskInRepo = repository.getTaskById('1');
      expect(taskInRepo, isNotNull);
      expect(taskInRepo!.title, equals('Updated Title'));
      expect(taskInRepo.completed, isTrue);
    });

    test('getTaskById() should return correct task or null if not found', () {
      // Arrange
      final task = Task(id: '10', title: 'Special Task');
      repository.addTask(task);

      // Act & Assert
      expect(repository.getTaskById('10')?.title, equals('Special Task'));
      expect(repository.getTaskById('non_existent'), isNull);
    });

    test('clear() should remove all tasks from repository', () {
      // Arrange
      repository.addTask(Task(id: '1', title: 'Task 1'));
      repository.addTask(Task(id: '2', title: 'Task 2'));
      expect(repository.tasks.length, equals(2));

      // Act
      repository.clear();

      // Assert
      expect(repository.tasks.isEmpty, isTrue);
    });
  });
}

