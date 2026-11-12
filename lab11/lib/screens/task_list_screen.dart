import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository? repository;

  const TaskListScreen({super.key, this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskRepository _repository;
  final TextEditingController _taskInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TaskRepository();
  }

  @override
  void dispose() {
    _taskInputController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskInputController.text.trim();
    if (title.isNotEmpty) {
      final task = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
      );
      _repository.addTask(task);
      _taskInputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _repository,
        builder: (context, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('taskInputField'),
                        controller: _taskInputController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a task...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      key: const Key('addTaskButton'),
                      onPressed: _addTask,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _repository.tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet. Add one!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _repository.tasks.length,
                        itemBuilder: (context, index) {
                          final task = _repository.tasks[index];
                          return ListTile(
                            key: Key('taskItem_${task.id}'),
                            leading: Checkbox(
                              value: task.completed,
                              onChanged: (_) {
                                task.toggle();
                                _repository.updateTask(task);
                              },
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _repository.deleteTask(task.id),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailScreen(
                                    task: task,
                                    repository: _repository,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

