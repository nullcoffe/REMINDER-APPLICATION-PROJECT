import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mengambil pengguna yang sedang login.
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

    // Identitas pemilik harus menggunakan UID Firebase.
    taskData['userId'] = user.uid;

    // Timestamp dibuat oleh server Firestore.
    taskData['createdAt'] =
        FieldValue.serverTimestamp();

    taskData['updatedAt'] =
        FieldValue.serverTimestamp();

    // Mempertahankan ID task dari TaskModel.
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .set(taskData);
  }
  // AMBIL TASK BERDASARKAN USER
  Stream<List<TaskModel>> getTasks(String userId) {
    final user = _requireUser();

    if (user.uid != userId) {
      throw Exception(
        'Tidak memiliki akses ke task pengguna lain.',
      );
    }

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }
  // UPDATE TASK
  Future<void> updateTask(TaskModel task) async {
    final user = _requireUser();

    final taskRef =
        _firestore.collection('tasks').doc(task.id);

    final taskData = task.toMap();

    // Field ini tidak boleh diubah saat update.
    taskData.remove('createdAt');
    taskData.remove('id');

    // Pertahankan identitas pemilik.
    taskData['userId'] = user.uid;

    taskData['updatedAt'] =
        FieldValue.serverTimestamp();

    // Sesuai dengan daftar field yang diizinkan
    // pada Firestore Rules terbaru.
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
    };

    taskData.removeWhere(
      (key, value) => !allowedFields.contains(key),
    );

    await taskRef.update(taskData);
  }

  // HAPUS TASK DAN CHECKLIST TERKAIT
  Future<void> deleteTask(String taskId) async {
    _requireUser();

    final taskRef =
        _firestore.collection('tasks').doc(taskId);

    // Cari checklist yang terhubung dengan task.
    final checklistSnapshot = await _firestore
        .collection('checklist')
        .where('taskId', isEqualTo: taskId)
        .get();

    // Hapus checklist terlebih dahulu agar task induk
    // masih tersedia saat rules memeriksa kepemilikan.
    for (final doc in checklistSnapshot.docs) {
      await doc.reference.delete();
    }

    // Hapus task setelah checklist berhasil dihapus.
    await taskRef.delete();
  }
}
