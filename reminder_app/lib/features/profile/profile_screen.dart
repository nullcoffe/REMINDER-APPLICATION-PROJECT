import 'package:flutter/material.dart';

import 'widgets/settings_tile.dart';
import 'widgets/logout_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Informasi pengguna
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor:
                      colorScheme.primary.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.person,
                    size: 46,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nama Pengguna',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'email@example.com',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    _showMessage(
                      context,
                      'Fitur edit profil belum dihubungkan.',
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Profil'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Pengaturan akun
          Text(
            'Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          SettingTile(
            icon: Icons.person_outline,
            title: 'Informasi Akun',
            subtitle: 'Kelola nama dan email',
            onTap: () {
              _showMessage(
                context,
                'Pengaturan informasi akun belum tersedia.',
              );
            },
          ),

          SettingTile(
            icon: Icons.lock_outline,
            title: 'Kata Sandi',
            subtitle: 'Ubah kata sandi akun',
            onTap: () {
              _showMessage(
                context,
                'Fitur ubah kata sandi belum tersedia.',
              );
            },
          ),

          const SizedBox(height: 16),

          // Preferensi aplikasi
          Text(
            'Preferensi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          SettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notifikasi',
            subtitle: 'Pengingat tugas dan deadline',
            onTap: () {
              _showMessage(
                context,
                'Pengaturan notifikasi belum tersedia.',
              );
            },
          ),

          SettingTile(
            icon: Icons.palette_outlined,
            title: 'Tema Aplikasi',
            subtitle: 'Atur tampilan aplikasi',
            onTap: () {
              _showMessage(
                context,
                'Pengaturan tema belum dihubungkan.',
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

          // Tombol keluar
          OutlinedButton.icon(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Keluar Akun'),
                    content: const Text(
                      'Apakah kamu yakin ingin keluar dari akun?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
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
              foregroundColor: colorScheme.error,
              side: BorderSide(
                color: colorScheme.error,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
