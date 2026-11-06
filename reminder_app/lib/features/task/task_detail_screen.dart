import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/task_model.dart';

// Layar detail tugas yang menerima objek TaskModel utuh.
class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  // Format tanggal dari Timestamp menjadi string yang mudah dibaca.
  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.taskDetailTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Judul tugas
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingSmall),

                // Tanggal tenggat waktu
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      _formatDate(task.deadline.toDate()),
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSizes.spacingLarge),

                // Deskripsi tugas
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeMedium,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}