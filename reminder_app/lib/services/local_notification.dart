
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static Future<void>? _initializationFuture;

  WebFlutterLocalNotificationsPlugin? get _webPlugin {
    return _notifications
        .resolvePlatformSpecificImplementation<
            WebFlutterLocalNotificationsPlugin>();
  }

  // =====================================================
  // INISIALISASI
  // =====================================================

  Future<void> initialize() async {
    if (_initialized) return;

    final pending = _initializationFuture;

    if (pending != null) {
      await pending;
      return;
    }

    final future = _initializeInternal();
    _initializationFuture = future;

    try {
      await future;
      _initialized = true;

      debugPrint(
        'LocalNotificationService berhasil diinisialisasi.',
      );
    } finally {
      if (identical(_initializationFuture, future)) {
        _initializationFuture = null;
      }
    }
  }

  Future<void> _initializeInternal() async {
    if (kIsWeb) {
      if (!WebFlutterLocalNotificationsPlugin.isSupported) {
        throw UnsupportedError(
          'Browser tidak mendukung Web Notifications API.',
        );
      }

      final webPlugin = _webPlugin;

      if (webPlugin == null) {
        throw StateError(
          'Web notification plugin tidak tersedia.',
        );
      }

      final initialized = await webPlugin.initialize();

      if (initialized != true) {
        throw StateError(
          'Gagal menginisialisasi notifikasi browser.',
        );
      }

      return;
    }

    tz_data.initializeTimeZones();

    final timezoneInfo =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(timezoneInfo.identifier),
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    await _notifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
      ),
    );
  }

  // =====================================================
  // MEMERIKSA STATUS IZIN
  // =====================================================

  Future<bool> isPermissionGranted() async {
    await initialize();

    if (kIsWeb) {
      return _webPlugin?.permissionStatus ==
          WebNotificationPermission.granted;
    }

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    return await androidPlugin.areNotificationsEnabled() ??
        false;
  }

  // =====================================================
  // MEMINTA IZIN
  // =====================================================

  Future<bool> requestPermission() async {
    await initialize();

    if (kIsWeb) {
      final webPlugin = _webPlugin;

      if (webPlugin == null) return false;

      if (webPlugin.permissionStatus ==
          WebNotificationPermission.granted) {
        return true;
      }

      final result =
          await webPlugin.requestNotificationsPermission();

      final granted =
          result == true ||
          webPlugin.permissionStatus ==
              WebNotificationPermission.granted;

      debugPrint(
        'Izin notifikasi Chrome: $granted',
      );

      return granted;
    }

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    return await androidPlugin.requestNotificationsPermission() ??
        false;
  }

  // =====================================================
  // ID NOTIFIKASI
  // =====================================================

  int _createNotificationId(String value) {
    int hash = 0;

    for (final codeUnit in value.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }

    return hash == 0 ? 1 : hash;
  }

  // =====================================================
  // MENAMPILKAN PENGINGAT
  // =====================================================

  Future<bool> showDeadlineReminder({
    required String notificationKey,
    required String taskTitle,
    required int daysBefore,
  }) async {
    await initialize();

    const title = 'Pengingat Deadline';

    final body = daysBefore == 0
        ? 'Tugas "$taskTitle" sudah mencapai deadline.'
        : 'Deadline tugas "$taskTitle" tersisa $daysBefore hari.';

    try {
      if (kIsWeb) {
        final webPlugin = _webPlugin;

        if (webPlugin == null ||
            webPlugin.permissionStatus !=
                WebNotificationPermission.granted) {
          debugPrint(
            'Izin notifikasi Chrome belum diberikan.',
          );

          return false;
        }

        await webPlugin.show(
          id: _createNotificationId(notificationKey),
          title: title,
          body: body,
          notificationDetails: const WebNotificationDetails(
            requireInteraction: true,
          ),
        );

        debugPrint(
          'Notifikasi Chrome berhasil dipanggil.',
        );

        return true;
      }

      await _notifications.show(
        id: _createNotificationId(notificationKey),
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'deadline_reminders',
            'Pengingat Deadline',
            channelDescription:
                'Pengingat deadline tugas mahasiswa.',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );

      debugPrint(
        'Notifikasi Android berhasil dipanggil.',
      );

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'Gagal menampilkan notifikasi: $error',
      );

      debugPrint('$stackTrace');

      return false;
    }
  }

  // =====================================================
  // PENJADWALAN ANDROID
  // =====================================================

  Future<void> scheduleDeadlineReminders({
    required int taskId,
    required String taskTitle,
    required DateTime deadline,
  }) async {
    await initialize();

    if (kIsWeb) {
      debugPrint(
        'Penjadwalan lokal masa depan tidak digunakan pada browser.',
      );
      return;
    }

    final now = tz.TZDateTime.now(tz.local);

    const reminderDays = [3, 2, 1];

    for (final daysBefore in reminderDays) {
      final reminderDate = DateTime(
        deadline.year,
        deadline.month,
        deadline.day,
      ).subtract(Duration(days: daysBefore));

      final scheduledDate = tz.TZDateTime(
        tz.local,
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        9,
      );

      if (!scheduledDate.isAfter(now)) continue;

      await _notifications.zonedSchedule(
        id: taskId * 10 + daysBefore,
        title: 'Pengingat Deadline',
        body:
            'Tugas "$taskTitle" jatuh tempo dalam $daysBefore hari.',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'deadline_reminders',
            'Pengingat Deadline',
            channelDescription:
                'Pengingat deadline tugas mahasiswa.',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode:
            AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  // =====================================================
  // MEMBATALKAN PENGINGAT
  // =====================================================

  Future<void> cancelDeadlineReminders(int taskId) async {
    for (final daysBefore in [3, 2, 1]) {
      await _notifications.cancel(
        id: taskId * 10 + daysBefore,
      );
    }
  }

  // =====================================================
  // MEMBATALKAN SEMUA NOTIFIKASI
  // =====================================================

  Future<void> cancelAllNotifications() async {
    if (kIsWeb) {
      await _webPlugin?.cancelAll();
      return;
    }

    await _notifications.cancelAll();
  }
}
