import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskRepository extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _tasks.clear();
    notifyListeners();
  }
}

