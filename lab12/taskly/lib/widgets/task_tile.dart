import 'package:flutter/material.dart';
import '../models/task.dart';

/// Isolated task row widget to keep list items modular and minimize rebuild scope.
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: task.completed
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.redAccent),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}

