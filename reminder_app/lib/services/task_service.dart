import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';


class TaskService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;



  // Tambah task
  Future<void> createTask(
    TaskModel task,
  ) async {

    await _firestore
        .collection('tasks')
        .doc(task.id)
        .set(
          task.toMap(),
        );

  }



  // Ambil task berdasarkan user
  Stream<List<TaskModel>> getTasks(
    String userId,
  ) {

    return _firestore
        .collection('tasks')
        .where(
          'userId',
          isEqualTo: userId,
        )
        .snapshots()
        .map(
          (snapshot) {

            return snapshot.docs
                .map(
                  (doc) => TaskModel.fromMap(
                    doc.data(),
                    doc.id,
                  ),
                )
                .toList();

          },
        );

  }



  // Update task
  Future<void> updateTask(
    TaskModel task,
  ) async {

    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update(
          task.toMap(),
        );

  }



  // Hapus task
  Future<void> deleteTask(
    String taskId,
  ) async {

    await _firestore
        .collection('tasks')
        .doc(taskId)
        .delete();

  }

}