import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/neu_card.dart';

// Card sapaan di bagian atas dashboard.
// Menampilkan salam, pesan motivasi, dan foto profil pengguna.
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Row(
        children: [
          // Bagian teks sapaan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Mahasiswa! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semangat tuntaskan kuliah, Urusan tugas ntar diingetin sama zilla-chan ya....',
                  style: TextStyle(
                    color: AppColors.tertiary,
                    fontSize: AppSizes.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Foto profil pengguna
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://via.placeholder.com/60',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
