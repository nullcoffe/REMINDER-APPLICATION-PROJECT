
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'local_notification.dart';

class NotificationService with WidgetsBindingObserver {
  // =====================================================
  // SINGLETON
  // =====================================================

  static final NotificationService _instance =
      NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal() {
    WidgetsBinding.instance.addObserver(this);

    // Memantau perubahan status login.
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          unawaited(
            _runAutomaticCheck(user.uid),
          );
        }
      },
      onError: (error) {
        debugPrint(
          'Notification auth listener error: $error',
        );
      },
    );

    // Pemeriksaan berkala setiap 15 menit.
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          unawaited(
            _runAutomaticCheck(user.uid),
          );
        }
      },
    );
  }

  // =====================================================
  // DEPENDENCIES
  // =====================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  StreamSubscription<User?>? _authSubscription;

  Timer? _periodicTimer;

  bool _isCheckingDeadline = false;

  static final Set<String> _processingNotificationIds = {};

  // =====================================================
  // PEMERIKSAAN OTOMATIS
  // =====================================================

  Future<void> _runAutomaticCheck(
    String userId,
  ) async {
    if (_isCheckingDeadline) return;

    if (FirebaseAuth.instance.currentUser?.uid != userId) {
      return;
    }

    try {
      debugPrint(
        'Memulai pemeriksaan deadline otomatis...',
      );

      final createdCount =
          await checkAndCreateDueReminders(
        userId: userId,
      );

      debugPrint(
        'Pemeriksaan otomatis selesai. '
        'Pengingat baru: $createdCount',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Gagal melakukan pemeriksaan otomatis: $error',
      );

      debugPrint('$stackTrace');
    }
  }

  // =====================================================
  // APPLICATION LIFECYCLE
  // =====================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        debugPrint(
          'Aplikasi aktif kembali. Memeriksa deadline...',
        );

        unawaited(
          _runAutomaticCheck(user.uid),
        );
      }
    }
  }

  // =====================================================
  // KOLEKSI NOTIFIKASI
  // =====================================================

  CollectionReference<Map<String, dynamic>> _userNotifications(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications');
  }

  // =====================================================
  // MENGAMBIL RIWAYAT NOTIFIKASI
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications(
    String userId,
  ) {
    return _userNotifications(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // =====================================================
  // MENGHITUNG NOTIFIKASI BELUM DIBACA
  // =====================================================

  Stream<int> getUnreadCount(String userId) {
    return _userNotifications(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.length,
        );
  }

  // =====================================================
  // MEMERIKSA DEADLINE
  // =====================================================

  Future<int> checkAndCreateDueReminders({
    required String userId,
    DateTime? currentTime,
  }) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError(
        'User ID tidak boleh kosong.',
      );
    }

    // Mencegah pemeriksaan bertumpuk.
    if (_isCheckingDeadline) {
      debugPrint(
        'Pemeriksaan deadline sedang berlangsung.',
      );

      return 0;
    }

    _isCheckingDeadline = true;

    try {
      await _localNotificationService.initialize();

      final now =
          (currentTime ?? DateTime.now()).toLocal();

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      // Mengambil tugas berdasarkan UID pengguna.
      final taskSnapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      int createdCount = 0;

      const reminderDays = [3, 2, 1];

      for (final taskDocument in taskSnapshot.docs) {
        final taskData = taskDocument.data();

        // Memeriksa status tugas.
        final status = (taskData['status'] ?? 'pending')
            .toString()
            .trim()
            .toLowerCase();

        if (status == 'done' ||
            status == 'completed' ||
            status == 'selesai') {
          continue;
        }

        // Memeriksa deadline.
        final deadlineValue = taskData['deadline'];

        if (deadlineValue is! Timestamp) {
          debugPrint(
            'Deadline tidak valid: ${taskDocument.id}',
          );

          continue;
        }

        final deadline =
            deadlineValue.toDate().toLocal();

        // Tidak mengingatkan tugas yang melewati deadline.
        if (!deadline.isAfter(now)) {
          continue;
        }

        final taskId = taskDocument.id;

        final taskTitle =
            taskData['title']?.toString() ??
            taskData['taskTitle']?.toString() ??
            'Tugas tanpa judul';

        // Memeriksa tanggal pembuatan tugas.
        final createdAtValue = taskData['createdAt'];

        final DateTime? taskCreatedAt =
            createdAtValue is Timestamp
                ? createdAtValue.toDate().toLocal()
                : null;

        for (final daysBefore in reminderDays) {
          // Menghitung tanggal pengingat.
          final reminderDate = DateTime(
            deadline.year,
            deadline.month,
            deadline.day,
          ).subtract(
            Duration(days: daysBefore),
          );

          final reminderDay = DateTime(
            reminderDate.year,
            reminderDate.month,
            reminderDate.day,
          );

          // Tidak membuat pengingat sebelum tugas dibuat.
          if (taskCreatedAt != null) {
            final createdDay = DateTime(
              taskCreatedAt.year,
              taskCreatedAt.month,
              taskCreatedAt.day,
            );

            if (createdDay.isAfter(reminderDay)) {
              continue;
            }
          } else if (reminderDay.isBefore(today)) {
            continue;
          }

          // Jadwal pengingat pukul 09.00.
          final scheduledAt = DateTime(
            reminderDate.year,
            reminderDate.month,
            reminderDate.day,
            9,
          );

          // Belum waktunya mengirim pengingat.
          if (scheduledAt.isAfter(now)) {
            continue;
          }

          final reminderType = 'H-$daysBefore';

          // Identitas unik berdasarkan tugas dan deadline.
          final notificationId =
              '${taskId}_${deadline.millisecondsSinceEpoch}_$reminderType';

          final notificationRef =
              _userNotifications(userId).doc(notificationId);

          final message =
              'Deadline tugas "$taskTitle" tersisa $daysBefore hari.';

          // Membuat riwayat jika belum tersedia.
          final wasCreated =
              await _firestore.runTransaction<bool>(
            (transaction) async {
              final existing =
                  await transaction.get(notificationRef);

              if (existing.exists) {
                return false;
              }

              transaction.set(notificationRef, {
                'taskId': taskId,
                'taskTitle': taskTitle,
                'title': 'Pengingat Deadline',
                'message': message,
                'reminderType': reminderType,
                'daysBefore': daysBefore,
                'deadline': deadlineValue,
                'scheduledAt':
                    Timestamp.fromDate(scheduledAt),
                'createdAt':
                    FieldValue.serverTimestamp(),
                'isRead': false,
                'source': 'deadline_reminder',
                'browserNotificationShown': false,
                'browserNotificationShownAt': null,
              });

              return true;
            },
          );

          if (wasCreated) {
            createdCount++;
          }

          // Mencegah pemrosesan ID yang sama secara bersamaan.
          if (!_processingNotificationIds.add(notificationId)) {
            debugPrint(
              'Notifikasi sedang diproses: $notificationId',
            );

            continue;
          }

          try {
            // Mengambil status terbaru notifikasi.
            final notificationSnapshot =
                await notificationRef.get();

            if (!notificationSnapshot.exists) {
              continue;
            }

            final notificationData =
                notificationSnapshot.data()!;

            final alreadyShown =
                notificationData['browserNotificationShown'] == true;

            if (alreadyShown) {
              debugPrint(
                'Notifikasi sudah ditampilkan: $notificationId',
              );

              continue;
            }

            // Menampilkan notifikasi.
            final wasShown =
                await _localNotificationService.showDeadlineReminder(
              notificationKey: notificationId,
              taskTitle: taskTitle,
              daysBefore: daysBefore,
            );

            if (!wasShown) {
              debugPrint(
                'Notifikasi belum berhasil ditampilkan: $notificationId',
              );

              continue;
            }

            // Menandai setelah pemanggilan berhasil.
            await notificationRef.update({
              'browserNotificationShown': true,
              'browserNotificationShownAt':
                  FieldValue.serverTimestamp(),
            });

            debugPrint(
              'Notifikasi berhasil diproses: $notificationId',
            );
          } catch (error, stackTrace) {
            debugPrint(
              'Kesalahan pemrosesan notifikasi: $error',
            );

            debugPrint('$stackTrace');
          } finally {
            _processingNotificationIds.remove(
              notificationId,
            );
          }
        }
      }

      debugPrint(
        'Pemeriksaan deadline selesai. '
        'Pengingat baru: $createdCount',
      );

      return createdCount;
    } finally {
      _isCheckingDeadline = false;
    }
  }

  // =====================================================
  // MENANDAI NOTIFIKASI SUDAH DIBACA
  // =====================================================

  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    await _userNotifications(userId)
        .doc(notificationId)
        .update({
      'isRead': true,
    });
  }

  // =====================================================
  // MEMBERSIHKAN LISTENER DAN TIMER
  // =====================================================

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);

    _periodicTimer?.cancel();
    _periodicTimer = null;

    await _authSubscription?.cancel();
    _authSubscription = null;

    debugPrint(
      'NotificationService berhasil dihentikan.',
    );
  }
}
