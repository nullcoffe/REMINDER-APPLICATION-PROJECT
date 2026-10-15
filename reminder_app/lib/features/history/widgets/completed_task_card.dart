import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/task_model.dart';

// Widget untuk menampilkan satu item tugas yang sudah selesai
class CompletedTaskCard extends StatelessWidget {
  final TaskModel task;

  const CompletedTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          children: [
            // Ikon status selesai
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            // Informasi judul dan deskripsi tugas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            // Badge tingkat kesulitan
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
              ),
              child: Text(
                task.difficultyLevel,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
