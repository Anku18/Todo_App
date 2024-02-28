import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firebase_services.dart';

var logger = SimpleLogger();

class TaskViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Stream<List<Task>> fetchTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    });
  }

  Future<void> addTask(String title, String description) async {
    await _firebaseService.addTask(title, description);
    fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    try {
      await _firebaseService.updateTask(task);
    } catch (e) {
      logger.info(e.toString());
    }
    fetchTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _firebaseService.deleteTask(taskId);
    fetchTasks();
  }

  void shareTask(BuildContext context, String title, String description) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share('$title\n$description',
        subject: 'Task Shared: $title',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  // final _tasks = ValueNotifier<List<Task>>([]);

  // TaskViewModel(String userId) {
  //   _listenForTasks(userId);
  // }

  // List<Task> get tasks => _tasks.value;

  // void addTask(String title, String description) async {
  //   final newTask = Task(
  //     id: _firestore.collection('tasks').doc().id,
  //     title: title,
  //     description: description,
  //     ownerId: FirebaseAuth.instance.currentUser!.uid,
  //     sharedWith: [FirebaseAuth.instance.currentUser!.uid],
  //   );
  //   try {
  //     await _firestore.collection('tasks').doc(newTask.id).set(newTask.toMap());
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   _tasks.value = [..._tasks.value, newTask];
  // }

  // void updateTask(Task task) async {
  //   await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  //   _tasks.value = _tasks.value.map((t) => t.id == task.id ? task : t).toList();
  // }

  // void deleteTask(Task task) async {
  //   await _firestore.collection('tasks').doc(task.id).delete();
  //   _tasks.value = _tasks.value.where((t) => t.id != task.id).toList();
  // }

  // void _listenForTasks(String userId) {
  //   log(userId);
  //   _firestore
  //       .collection('tasks')
  //       .where('ownerId', isEqualTo: userId)
  //       .where('sharedWith', arrayContains: userId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     log(snapshot.docs.length.toString());
  //     final tasks =
  //         snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();

  //     _tasks.value = tasks;
  //   });
  // }
}
