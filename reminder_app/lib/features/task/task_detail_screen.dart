import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

class TaskDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const TaskDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

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
                // Judul Tugas
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingSmall),

                // Tanggal / Tenggat Waktu
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSizes.spacingLarge),

                // Deskripsi Tugas
                Text(
                  description,
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