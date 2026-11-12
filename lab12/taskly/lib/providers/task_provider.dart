import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

/// State management provider wrapping [TaskRepository] for selective UI rebuilds.
class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  late List<Task> _tasks;

  TaskProvider({TaskRepository? repository})
      : _repository = repository ?? TaskRepository() {
    _tasks = List.unmodifiable(_repository.tasks);
    _repository.addListener(_syncFromRepository);
  }

  TaskRepository get repository => _repository;

  /// Unmodifiable snapshot so [Selector] detects list and item changes accurately.
  List<Task> get tasks => _tasks;

  void _syncFromRepository() {
    _tasks = List.unmodifiable(_repository.tasks);
    notifyListeners();
  }

  void addTask(Task task) {
    _repository.addTask(task);
  }

  void toggleTask(String id) {
    final existing = _repository.getTaskById(id);
    if (existing == null) return;
    // Create an immutable copy so Selector detects the state change without mutating prior snapshots.
    _repository.updateTask(existing.copyWith(completed: !existing.completed));
  }

  void updateTask(Task task) {
    _repository.updateTask(task);
  }

  void deleteTask(String id) {
    _repository.deleteTask(id);
  }

  Task? getTaskById(String id) => _repository.getTaskById(id);

  void clear() {
    _repository.clear();
  }

  @override
  void dispose() {
    _repository.removeListener(_syncFromRepository);
    super.dispose();
  }
}

