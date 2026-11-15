import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login.');
    }
    return user;
  }

  // TAMBAH TASK
  Future<void> createTask(TaskModel task) async {
    final user = _requireUser();

    final taskData = task.toMap();
    taskData['userId'] = user.uid;
    taskData['createdAt'] = FieldValue.serverTimestamp();
    taskData['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.collection('tasks').doc(task.id).set(taskData);
  }

  // AMBIL TASK AKTIF (tidak terhapus)
  Stream<List<TaskModel>> getTasks(String userId) {
    final user = _requireUser();

    if (user.uid != userId) {
      throw Exception('Tidak memiliki akses ke task pengguna lain.');
    }

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .where((task) => !task.isDeleted)
              .toList();
        });
  }

  // AMBIL TASK YANG SUDAH SELESAI (untuk riwayat)
  Stream<List<TaskModel>> getCompletedTasks(String userId) {
    final user = _requireUser();

    if (user.uid != userId) {
      throw Exception('Tidak memiliki akses ke task pengguna lain.');
    }

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .where((task) {
                final statusLower = task.status.toLowerCase();
                return (statusLower == 'completed' || statusLower == 'done') &&
                    !task.isDeleted;
              })
              .toList();
        });
  }

  // AMBIL TASK YANG DIHAPUS (soft delete)
  Stream<List<TaskModel>> getDeletedTasks(String userId) {
    final user = _requireUser();

    if (user.uid != userId) {
      throw Exception('Tidak memiliki akses ke task pengguna lain.');
    }

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .where((task) => task.isDeleted)
              .toList();
        });
  }

  // UPDATE TASK
  Future<void> updateTask(TaskModel task) async {
    final user = _requireUser();

    final taskRef = _firestore.collection('tasks').doc(task.id);
    final taskData = task.toMap();

    taskData.remove('createdAt');
    taskData.remove('id');
    taskData['userId'] = user.uid;
    taskData['updatedAt'] = FieldValue.serverTimestamp();

    const allowedFields = {
      'title',
      'deadline',
      'priorityScore',
      'categoryId',
      'description',
      'difficultyLevel',
      'status',
      'userId',
      'updatedAt',
      'isDeleted',
      'deletedAt',
    };

    taskData.removeWhere((key, value) => !allowedFields.contains(key));

    await taskRef.update(taskData);
  }

  // SOFT DELETE - tandai tugas sebagai terhapus
  Future<void> deleteTask(String taskId) async {
    _requireUser();

    final taskRef = _firestore.collection('tasks').doc(taskId);

    await taskRef.update({
      'isDeleted': true,
      'deletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // HAPUS PERMANEN - hapus tugas dan checklist terkait dari Firestore
  Future<void> permanentDeleteTask(String taskId) async {
    _requireUser();

    final taskRef = _firestore.collection('tasks').doc(taskId);

    final checklistSnapshot = await _firestore
        .collection('checklist')
        .where('taskId', isEqualTo: taskId)
        .get();

    for (final doc in checklistSnapshot.docs) {
      await doc.reference.delete();
    }

    await taskRef.delete();
  }

  // RESTORE - kembalikan tugas yang terhapus ke daftar aktif
  Future<void> restoreTask(String taskId) async {
    _requireUser();

    final taskRef = _firestore.collection('tasks').doc(taskId);

    await taskRef.update({
      'isDeleted': false,
      'deletedAt': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
