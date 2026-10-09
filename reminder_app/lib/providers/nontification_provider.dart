import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../services/firestore_service.dart';

class NotificationProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _notificationsSubscription;

  StreamSubscription<int>? _unreadCountSubscription;

  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _unreadCount;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Mengambil notifikasi milik pengguna.
  void listenNotifications(String userId) {
    _notificationsSubscription?.cancel();
    _unreadCountSubscription?.cancel();

    _isLoading = true;
    _errorMessage = null;
    _notifications = [];
    _unreadCount = 0;

    notifyListeners();

    _notificationsSubscription =
        _firestoreService.getNotifications(userId).listen(
      (snapshot) {
        _notifications = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();

        _isLoading = false;
        _errorMessage = null;

        notifyListeners();
      },
      onError: (Object error) {
        _isLoading = false;
        _errorMessage = 'Gagal mengambil daftar notifikasi.';

        notifyListeners();
      },
    );

    _unreadCountSubscription =
        _firestoreService.getUnreadCount(userId).listen(
      (unreadTotal) {
        _unreadCount = unreadTotal;
        notifyListeners();
      },
      onError: (Object error) {
        _errorMessage = 'Gagal menghitung notifikasi yang belum dibaca.';

        notifyListeners();
      },
    );
  }

  // Menandai notifikasi sebagai sudah dibaca.
  Future<bool> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _firestoreService.markAsRead(
        userId: userId,
        notificationId: notificationId,
      );

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menandai notifikasi sebagai sudah dibaca.';
      notifyListeners();
      return false;
    }
  }

  // Menghentikan pemantauan notifikasi pengguna.
  Future<void> stopListening() async {
    await _notificationsSubscription?.cancel();
    await _unreadCountSubscription?.cancel();

    _notificationsSubscription = null;
    _unreadCountSubscription = null;

    _notifications = [];
    _unreadCount = 0;
    _isLoading = false;
    _errorMessage = null;

    notifyListeners();
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    _unreadCountSubscription?.cancel();

    super.dispose();
  }
}

