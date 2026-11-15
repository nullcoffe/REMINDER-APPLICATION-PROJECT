
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import 'notification_service.dart';

class TaskService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final NotificationService _notificationService =
      NotificationService();

  // =====================================================
  // VALIDASI PENGGUNA
  // =====================================================

  User _requireUser() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user;
  }

  // =====================================================
  // VALIDASI KEPEMILIKAN TASK
  // =====================================================

  Future<DocumentSnapshot<Map<String, dynamic>>>
      _getOwnedTask(
    String taskId,
    User user,
  ) async {
    final taskRef = _firestore
        .collection('tasks')
        .doc(taskId);

    final snapshot = await taskRef.get();

    if (!snapshot.exists) {
      throw Exception('Tugas tidak ditemukan.');
    }

    final taskData = snapshot.data();

    if (taskData?['userId'] != user.uid) {
      throw Exception(
        'Tidak memiliki akses ke tugas ini.',
      );
    }

    return snapshot;
  }

  // =====================================================
  // PEMERIKSAAN NOTIFIKASI
  // =====================================================

  Future<void> _refreshDeadlineReminders(
    String userId,
  ) async {
    try {
      final createdCount =
          await _notificationService.checkAndCreateDueReminders(
        userId: userId,
      );

      debugPrint(
        'Pemeriksaan deadline selesai. '
        'Pengingat baru: $createdCount',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Gagal memperbarui pemeriksaan deadline: $error',
      );

      debugPrint('$stackTrace');
    }
  }

  // =====================================================
  // TAMBAH TASK
  // =====================================================

  Future<void> createTask(TaskModel task) async {
    final user = _requireUser();

    if (task.id.trim().isEmpty) {
      throw ArgumentError(
        'ID tugas tidak boleh kosong.',
      );
    }

    final taskRef = _firestore
        .collection('tasks')
        .doc(task.id);

    final taskData = task.toMap();

    taskData['userId'] = user.uid;

    taskData['createdAt'] =
        FieldValue.serverTimestamp();

    taskData['updatedAt'] =
        FieldValue.serverTimestamp();

    debugPrint('========== CREATE TASK ==========');
    debugPrint(
      'PROJECT ID: ${_firestore.app.options.projectId}',
    );
    debugPrint('AUTH UID: ${user.uid}');
    debugPrint('TASK ID: ${task.id}');
    debugPrint('TASK DATA: $taskData');
    debugPrint('=================================');

    // Simpan task tanpa membaca dokumen terlebih dahulu.
    await taskRef.set(taskData);

    debugPrint(
      'TASK BERHASIL DISIMPAN: ${task.id}',
    );

    // Periksa pengingat deadline setelah penyimpanan.
    await _refreshDeadlineReminders(user.uid);
  }

  // =====================================================
  // AMBIL TASK AKTIF
  // =====================================================

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
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(
                doc.data(),
                doc.id,
              ))
          .where((task) => !task.isDeleted)
          .toList();
    });
  }

  // =====================================================
  // AMBIL TASK SELESAI (RIWAYAT)
  // =====================================================

  Stream<List<TaskModel>> getCompletedTasks(
    String userId,
  ) {
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
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(
                doc.data(),
                doc.id,
              ))
          .where((task) {
        final statusLower = task.status.toLowerCase();

        return (statusLower == 'completed' ||
                statusLower == 'done') &&
            !task.isDeleted;
      }).toList();
    });
  }

  // =====================================================
  // AMBIL TASK TERHAPUS (SAMPAH)
  // =====================================================

  Stream<List<TaskModel>> getDeletedTasks(
    String userId,
  ) {
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
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(
                doc.data(),
                doc.id,
              ))
          .where((task) => task.isDeleted)
          .toList();
    });
  }

  // =====================================================
  // UPDATE TASK
  // =====================================================

  Future<void> updateTask(TaskModel task) async {
    final user = _requireUser();

    final taskRef = _firestore
        .collection('tasks')
        .doc(task.id);

    // Pastikan task tersedia dan dimiliki pengguna.
    await _getOwnedTask(task.id, user);

    final taskData = task.toMap();

    taskData.remove('createdAt');
    taskData.remove('id');

    taskData['userId'] = user.uid;

    taskData['updatedAt'] =
        FieldValue.serverTimestamp();

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

    taskData.removeWhere(
      (key, value) => !allowedFields.contains(key),
    );

    await taskRef.update(taskData);

    debugPrint(
      'TASK BERHASIL DIPERBARUI: ${task.id}',
    );

    await _refreshDeadlineReminders(user.uid);
  }

  // =====================================================
  // SOFT DELETE
  // =====================================================

  Future<void> deleteTask(String taskId) async {
    final user = _requireUser();

    final taskRef = _firestore
        .collection('tasks')
        .doc(taskId);

    // Validasi kepemilikan task.
    await _getOwnedTask(taskId, user);

    // Task dipindahkan ke sampah, bukan dihapus permanen.
    await taskRef.update({
      'isDeleted': true,
      'deletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint(
      'TASK DIPINDAHKAN KE SAMPAH: $taskId',
    );

    await _refreshDeadlineReminders(user.uid);
  }

  // =====================================================
  // PERMANENT DELETE
  // =====================================================

  Future<void> permanentDeleteTask(
    String taskId,
  ) async {
    final user = _requireUser();

    final taskRef = _firestore
        .collection('tasks')
        .doc(taskId);

    // Pastikan pengguna memiliki task.
    await _getOwnedTask(taskId, user);

    // Ambil checklist yang terhubung dengan task.
    final checklistSnapshot = await _firestore
        .collection('checklist')
        .where('taskId', isEqualTo: taskId)
        .get();

    // Hapus checklist terlebih dahulu.
    for (final document in checklistSnapshot.docs) {
      await document.reference.delete();
    }

    // Hapus task induk setelah checklist.
    await taskRef.delete();

    debugPrint(
      'TASK DIHAPUS PERMANEN: $taskId',
    );

    await _refreshDeadlineReminders(user.uid);
  }

  // =====================================================
  // RESTORE TASK
  // =====================================================

  Future<void> restoreTask(String taskId) async {
    final user = _requireUser();

    final taskRef = _firestore
        .collection('tasks')
        .doc(taskId);

    // Validasi kepemilikan task.
    await _getOwnedTask(taskId, user);

    // Kembalikan task ke daftar aktif.
    await taskRef.update({
      'isDeleted': false,
      'deletedAt': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint(
      'TASK BERHASIL DIPULIHKAN: $taskId',
    );

    await _refreshDeadlineReminders(user.uid);
  }
}
