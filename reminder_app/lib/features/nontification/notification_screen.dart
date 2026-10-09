import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'Belum ada notifikasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pengingat tugas dan deadline kamu akan muncul di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

