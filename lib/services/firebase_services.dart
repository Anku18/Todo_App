import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/view_models/task_view_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> getTasks() async {
    QuerySnapshot querySnapshot = await _firestore.collection('tasks').get();
    return querySnapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTask(String title, String description) async {
    var id = _firestore.collection('tasks').doc().id;
    final newTask = Task(
        id: id,
        title: title,
        description: description,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString());
    await _firestore.collection('tasks').doc(id).set(newTask.toMap());
  }

  Future<void> updateTask(Task task) async {
    try {
      logger.info(task.toMap());
      await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap())
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } catch (e) {
      logger.info(e.toString());
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      logger.info('Error deleting task: $e');
      // Handle the error appropriately, such as logging or notifying the user.
    }
  }
}
