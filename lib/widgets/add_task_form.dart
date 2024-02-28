import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/view_models/task_view_model.dart';
import 'package:todo_app/widgets/task_widget.dart';

// ignore: must_be_immutable
class AddTaskDialog extends StatefulWidget {
  final TaskViewModel taskViewModel;
  Task? task;
  AddTaskDialog({
    Key? key,
    required this.taskViewModel,
    this.task,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
    super.initState();
  }

  void _addAndUpdateTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isNotEmpty && description.isNotEmpty) {
      if (widget.task != null) {
        widget.taskViewModel.updateTask(
            widget.task!.copyWith(title: title, description: description));
        showSnackBar(context, 'Task edited successfully!');
        Navigator.pop(context);
        return;
      }
      widget.taskViewModel.addTask(title, description);
      showSnackBar(context, 'Task added successfully!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.task == null ? 'Add Task' : 'Edit Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: _addAndUpdateTask,
              child: Text(
                widget.task == null ? 'Add Task' : 'Edit Task',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
