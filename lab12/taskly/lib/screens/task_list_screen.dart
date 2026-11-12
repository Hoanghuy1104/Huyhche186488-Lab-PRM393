import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../repositories/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository? repository;

  const TaskListScreen({super.key, this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  static const AssetImage _logoAsset = AssetImage('assets/images/taskly_logo.png');

  final TextEditingController _taskInputController = TextEditingController();
  TaskProvider? _fallbackProvider;
  bool _hasAncestorProvider = false;
  bool _isLogoPrecached = false;

  @override
  void initState() {
    super.initState();
    _hasAncestorProvider = _checkAncestorProvider();
    if (!_hasAncestorProvider) {
      _fallbackProvider = TaskProvider(repository: widget.repository);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLogoPrecached) {
      precacheImage(_logoAsset, context);
      _isLogoPrecached = true;
    }
  }

  bool _checkAncestorProvider() {
    try {
      Provider.of<TaskProvider>(context, listen: false);
      return true;
    } on ProviderNotFoundException {
      return false;
    }
  }

  @override
  void dispose() {
    _taskInputController.dispose();
    _fallbackProvider?.dispose();
    super.dispose();
  }

  void _addTask(TaskProvider provider) {
    final title = _taskInputController.text.trim();
    if (title.isNotEmpty) {
      final task = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
      );
      provider.addTask(task);
      _taskInputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Builder(
      builder: (innerContext) => Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: _logoAsset,
                width: 28,
                height: 28,
              ),
              SizedBox(width: 8),
              Text('Taskly'),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _TaskInputSection(
              controller: _taskInputController,
              onAdd: () => _addTask(innerContext.read<TaskProvider>()),
            ),
            const Divider(height: 1),
            Expanded(
              child: Selector<TaskProvider, List<Task>>(
                selector: (_, provider) => provider.tasks,
                builder: (context, tasks, _) {
                  if (tasks.isEmpty) {
                    return const _EmptyTasksView(logoAsset: _logoAsset);
                  }
                  final provider = context.read<TaskProvider>();
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        key: ValueKey(task.id),
                        task: task,
                        onToggle: () => provider.toggleTask(task.id),
                        onDelete: () => provider.deleteTask(task.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(
                                task: task,
                                repository: provider.repository,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (_hasAncestorProvider) {
      return content;
    }
    return ChangeNotifierProvider<TaskProvider>.value(
      value: _fallbackProvider!,
      child: content,
    );
  }
}

class _TaskInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _TaskInputSection({
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('taskInputField'),
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter a task...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => onAdd(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            key: const Key('addTaskButton'),
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasksView extends StatelessWidget {
  final AssetImage logoAsset;

  const _EmptyTasksView({required this.logoAsset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: logoAsset,
            width: 64,
            height: 64,
          ),
          const SizedBox(height: 12),
          const Text(
            'No tasks yet. Add one!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
