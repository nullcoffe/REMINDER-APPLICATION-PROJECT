import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/neu_card.dart';

// Widget yang ditampilkan ketika belum ada tugas aktif.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NeuCard(
      padding: const EdgeInsets.all(AppSizes.spaceXL),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.spa, color: colorScheme.onPrimary, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Santai Dulu',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            'Belum Ada Tugas Aktif',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            'Jadwal kuliahmu masih kosong dan santai.\nYuk, mulai tambahkan tugas kuliah atau praktikum pertamamu!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: AppSizes.fontSizeSmall,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addTask);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('+ Tambah Tugas Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
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
