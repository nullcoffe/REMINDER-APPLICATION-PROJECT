import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_sizes.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _taskReminder = true;
  bool _deadlineReminder = true;
  bool _dailySummary = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _taskReminder = prefs.getBool('notif_task') ?? true;
      _deadlineReminder = prefs.getBool('notif_deadline') ?? true;
      _dailySummary = prefs.getBool('notif_daily') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSizes.pagePadding),
              children: [
                Text(
                  'Pengingat Tugas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _switchTile(
                  icon: Icons.task_alt_outlined,
                  title: 'Pengingat Tugas Baru',
                  subtitle: 'Notifikasi saat ada tugas baru ditambahkan',
                  value: _taskReminder,
                  onChanged: (v) {
                    setState(() => _taskReminder = v);
                    _saveSetting('notif_task', v);
                  },
                ),
                const SizedBox(height: 12),
                _switchTile(
                  icon: Icons.timer_outlined,
                  title: 'Pengingat Deadline',
                  subtitle: 'Notifikasi 1 hari sebelum deadline',
                  value: _deadlineReminder,
                  onChanged: (v) {
                    setState(() => _deadlineReminder = v);
                    _saveSetting('notif_deadline', v);
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Lainnya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _switchTile(
                  icon: Icons.summarize_outlined,
                  title: 'Ringkasan Harian',
                  subtitle: 'Terima ringkasan tugas setiap pagi',
                  value: _dailySummary,
                  onChanged: (v) {
                    setState(() => _dailySummary = v);
                    _saveSetting('notif_daily', v);
                  },
                ),
              ],
            ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cs.primary),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        value: value,
        activeColor: cs.primary,
        onChanged: onChanged,
      ),
    );
  }
}
