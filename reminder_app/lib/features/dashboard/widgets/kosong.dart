import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/neu_card.dart';

// Widget yang ditampilkan ketika belum ada tugas aktif.
// Berisi ilustrasi logo, pesan motivasi, dan tombol untuk menambah tugas.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.all(AppSizes.spaceXL),
      child: Column(
        children: [
          // Logo TaskZilla
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              child: Image.asset(
                'assets/logotaskzilla.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // Badge "Santai Dulu"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.spa, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                const Text(
                  'Santai Dulu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // Judul dan Deskripsi
          const Text(
            'Belum Ada Tugas Aktif',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            'Jadwal kuliahmu masih kosong dan santai.\nYuk, mulai tambahkan tugas kuliah atau praktikum pertamamu!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.fontSizeSmall,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // Tombol Tambah Tugas
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addTask);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('+ Tambah Tugas Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
