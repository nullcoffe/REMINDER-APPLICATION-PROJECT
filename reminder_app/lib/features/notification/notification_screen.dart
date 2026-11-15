
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/notification_service.dart';
import '../../services/local_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final user = FirebaseAuth.instance.currentUser;

    final notificationService = NotificationService();

    final localNotificationService =
        LocalNotificationService();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifikasi'),
        ),
        body: const Center(
          child: Text(
            'Silakan login untuk melihat notifikasi.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          // Tombol aktivasi izin notifikasi.
          IconButton(
            tooltip: 'Aktifkan Notifikasi',
            icon: const Icon(
              Icons.notifications_active_outlined,
            ),
            onPressed: () async {
              try {
                // Meminta izin melalui interaksi pengguna.
                final granted =
                    await localNotificationService.requestPermission();

                if (!context.mounted) return;

                if (!granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Izin notifikasi belum diberikan. '
                        'Periksa pengaturan situs Chrome.',
                      ),
                    ),
                  );

                  return;
                }

                // Memeriksa deadline setelah izin diberikan.
                final createdCount =
                    await notificationService.checkAndCreateDueReminders(
                  userId: user.uid,
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Notifikasi aktif. '
                      'Pemeriksaan selesai. '
                      'Pengingat baru: $createdCount.',
                    ),
                  ),
                );
              } catch (error) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal mengaktifkan notifikasi: $error',
                    ),
                  ),
                );
              }
            },
          ),

          // Jumlah notifikasi belum dibaca.
          StreamBuilder<int>(
            stream: notificationService.getUnreadCount(
              user.uid,
            ),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;

              return Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                ),
                child: Center(
                  child: Text(
                    'Belum dibaca: $unreadCount',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // Riwayat notifikasi.
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: notificationService.getNotifications(
          user.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Gagal memuat notifikasi. '
                'Periksa koneksi atau izin.',
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notifications =
              snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: colorScheme.primary,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Belum ada notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Pengingat tugas dan deadline kamu '
                      'akan muncul di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final document = notifications[index];

              final data = document.data();

              final message =
                  data['message']?.toString() ??
                  'Ada pengingat tugas untuk kamu.';

              final isRead = data['isRead'] == true;

              final createdAt = data['createdAt'];

              String dateText = '';

              if (createdAt is Timestamp) {
                final date = createdAt.toDate().toLocal();

                dateText =
                    '${date.day.toString().padLeft(2, '0')}/'
                    '${date.month.toString().padLeft(2, '0')}/'
                    '${date.year} '
                    '${date.hour.toString().padLeft(2, '0')}:'
                    '${date.minute.toString().padLeft(2, '0')}';
              }

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: ListTile(
                  leading: Icon(
                    isRead
                        ? Icons.notifications_none
                        : Icons.notifications_active,
                    color: isRead
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
                  ),

                  title: Text(
                    message,
                    style: TextStyle(
                      fontWeight: isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),

                  subtitle: dateText.isEmpty
                      ? null
                      : Text(dateText),

                  trailing: isRead
                      ? const Icon(
                          Icons.check,
                          size: 20,
                        )
                      : const Icon(
                          Icons.circle,
                          size: 10,
                        ),

                  onTap: isRead
                      ? null
                      : () async {
                          try {
                            await notificationService.markAsRead(
                              userId: user.uid,
                              notificationId: document.id,
                            );
                          } catch (error) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Gagal menandai notifikasi '
                                  'sebagai dibaca.',
                                ),
                              ),
                            );
                          }
                        },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
