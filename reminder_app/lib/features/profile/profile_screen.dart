import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app/routes/app_routes.dart';
import 'widgets/settings_tile.dart';
import 'widgets/logout_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _displayName = 'Nama Pengguna';
  String _email = 'email@example.com';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _email = user.email ?? 'email@example.com';
      _displayName = user.displayName ?? 'Nama Pengguna';
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()?['displayName'] != null) {
        if (mounted) {
          setState(() {
            _displayName = doc.data()!['displayName'] as String;
          });
        }
      }
    } catch (e) {
      debugPrint('Gagal memuat data user: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outline),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: cs.primary.withValues(alpha: 0.12),
                        child: Icon(Icons.person, size: 46, color: cs.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _displayName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRoutes.editProfile,
                          );
                          if (result == true) _loadUserData();
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Profil'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.primary,
                          side: BorderSide(color: cs.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                SettingTile(
                  icon: Icons.person_outline,
                  title: 'Informasi Akun',
                  subtitle: 'Kelola nama dan email',
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.editProfile,
                    );
                    if (result == true) _loadUserData();
                  },
                ),
                SettingTile(
                  icon: Icons.lock_outline,
                  title: 'Kata Sandi',
                  subtitle: 'Ubah kata sandi akun',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Preferensi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                SettingTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  subtitle: 'Pengingat tugas dan deadline',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.notificationSettings,
                    );
                  },
                ),
                SettingTile(
                  icon: Icons.palette_outlined,
                  title: 'Tema Aplikasi',
                  subtitle: 'Atur tampilan aplikasi',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.themeSettings,
                      arguments: {
                        'themeMode':
                            Theme.of(context).brightness == Brightness.dark
                            ? ThemeMode.dark
                            : ThemeMode.light,
                        'onThemeChanged': (ThemeMode mode) {
                          // Callback akan dihandle oleh parent
                        },
                      },
                    );
                  },
                ),
                SettingTile(
                  icon: Icons.info_outline,
                  title: 'Tentang TaskZilla',
                  subtitle: 'Informasi aplikasi',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'TaskZilla',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          'Aplikasi pengelola tugas mahasiswa.',
                    );
                  },
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          backgroundColor: cs.surface,
                          title: const Text('Keluar Akun'),
                          content: const Text(
                            'Apakah kamu yakin ingin keluar dari akun?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Batal'),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                jalankanLogout(context);
                              },
                              child: const Text('Keluar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar Akun'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.error,
                    side: BorderSide(color: cs.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
