import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/view_models/task_view_model.dart';
import 'package:todo_app/widgets/add_task_form.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final TaskViewModel taskViewModel;

  const TaskTile({
    Key? key,
    required this.taskViewModel,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) =>
                    AddTaskDialog(taskViewModel: taskViewModel, task: task),
              );
            },
            backgroundColor: const Color(0xFF9575CD),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              taskViewModel.shareTask(context, task.title, task.description);
            },
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              taskViewModel.deleteTask(task.id);
              showSnackBar(context, 'Task deleted successfully!');
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: CheckboxListTile(
          value: task.completed,
          title: Text(
            task.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: task.description.isNotEmpty
              ? Text(
                  task.description,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                )
              : null,
          onChanged: (newValue) {
            log(newValue.toString());
            taskViewModel.updateTask(
              task.copyWith(completed: newValue!),
            );
          }),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 500),
      backgroundColor: Theme.of(context).primaryColor,
      content: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
