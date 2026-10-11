import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Inisialisasi layanan notifikasi.
  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(timezoneInfo.identifier),
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
    );

    _initialized = true;
  }

  // Meminta izin notifikasi pada Android.
  Future<bool> requestPermission() async {
    await initialize();

    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return false;
    }

    return await androidImplementation.requestNotificationsPermission() ??
        false;
  }

  // Menjadwalkan pengingat deadline H-3, H-2, dan H-1.
  // Notifikasi dijadwalkan pukul 09.00 waktu lokal.
  Future<void> scheduleDeadlineReminders({
    required int taskId,
    required String taskTitle,
    required DateTime deadline,
  }) async {
    await initialize();

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

      // Lewati pengingat jika waktunya sudah lewat.
      if (!scheduledDate.isAfter(now)) {
        continue;
      }

      await _notifications.zonedSchedule(
        id: taskId * 10 + daysBefore,
        title: 'Pengingat Deadline',
        body: 'Tugas "$taskTitle" jatuh tempo dalam $daysBefore hari.',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'deadline_reminders',
            'Pengingat Deadline',
            channelDescription: 'Pengingat deadline tugas mahasiswa.',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  // Membatalkan pengingat untuk suatu tugas.
  Future<void> cancelDeadlineReminders(int taskId) async {
    for (final daysBefore in [3, 2, 1]) {
      await _notifications.cancel(
        id: taskId * 10 + daysBefore,
      );
    }
  }

  // Membatalkan semua notifikasi lokal.
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}