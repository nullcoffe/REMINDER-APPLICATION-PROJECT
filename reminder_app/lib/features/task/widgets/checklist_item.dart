
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

/// Widget untuk menampilkan satu item tugas dengan checkbox.
/// Widget ini menampilkan judul dan status penyelesaian tugas.
class ChecklistItem extends StatelessWidget {
  // Judul tugas yang ditampilkan.
  final String title;

  // Status tugas: selesai atau belum selesai.
  final bool isCompleted;

  // Callback untuk menangani perubahan status checkbox.
  final ValueChanged<bool?>? onChanged;

  const ChecklistItem({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      // Nilai checkbox mengikuti status tugas.
      value: isCompleted,
      onChanged: onChanged,
      activeColor: AppColors.primaryTeal,
      controlAffinity: ListTileControlAffinity.leading,

      // Mengatur jarak di dalam komponen.
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS / 2,
      ),

      // Mengatur sudut komponen agar konsisten.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.radiusDefault,
        ),
      ),

      // Menampilkan judul tugas.
      // Judul dicoret jika tugas sudah selesai.
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          color: isCompleted
              ? AppColors.textSecondary
              : AppColors.textPrimary,
          decoration: isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),

      // Menampilkan status tugas.
      subtitle: Text(
        isCompleted
            ? AppStrings.statusDone
            : AppStrings.statusTodo,
        style: const TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
