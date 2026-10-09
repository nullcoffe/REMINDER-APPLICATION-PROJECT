import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Meminta izin notifikasi kepada pengguna.
  Future<NotificationSettings> requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Mengambil token perangkat untuk Firebase Cloud Messaging.
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Gagal mengambil token FCM: $e');
      return null;
    }
  }

  // Mendengarkan notifikasi ketika aplikasi sedang dibuka.
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Notifikasi diterima saat aplikasi aktif.');

      if (message.notification != null) {
        debugPrint('Judul: ${message.notification!.title}');
        debugPrint('Isi: ${message.notification!.body}');
      }
    });
  }

  // Mendengarkan ketika pengguna membuka notifikasi.
  void listenNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Pengguna membuka notifikasi.');
      debugPrint('Data notifikasi: ${message.data}');
    });
  }

  // Memeriksa apakah aplikasi dibuka melalui notifikasi.
  Future<RemoteMessage?> getInitialMessage() async {
    return await _messaging.getInitialMessage();
  }
}

