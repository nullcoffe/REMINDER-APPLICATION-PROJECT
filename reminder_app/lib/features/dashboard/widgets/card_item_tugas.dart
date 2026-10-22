
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/neu_card.dart';
import '../../../models/task_model.dart';
import '../../../services/task_service.dart';

// Kartu tugas pada dashboard.
class TaskCardItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCardItem({
    super.key,
    required this.task,
    this.onTap,
  });

  bool get _isUrgent => task.priorityScore >= 8;

  bool get _isCompleted =>
      task.status.toLowerCase() == 'completed';

  String get _deadlineText {
    final date = task.deadline.toDate();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Simpan perubahan status tugas ke Firestore.
  Future<void> _toggleCompletion(
    BuildContext context,
    bool? value,
  ) async {
    if (value == null || value == _isCompleted) return;

    final updatedTask = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      userId: task.userId,
      deadline: task.deadline,
      difficultyLevel: task.difficultyLevel,
      priorityScore: task.priorityScore,
      status: value ? 'completed' : 'to-do',
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );

    try {
      await TaskService().updateTask(updatedTask);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status tugas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _isCompleted ? 1.0 : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: NeuCard(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori dan deadline.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.categoryId.isNotEmpty
                        ? task.categoryId
                        : 'Umum',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isUrgent
                        ? Colors.redAccent.withValues(alpha: 0.2)
                        : AppColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: _isUrgent
                            ? Colors.redAccent
                            : AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _deadlineText,
                        style: TextStyle(
                          color: _isUrgent
                              ? Colors.redAccent
                              : AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Checkbox, judul, dan deskripsi.
            Row(
              children: [
                Checkbox(
                  value: _isCompleted,
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  onChanged: (value) =>
                      _toggleCompletion(context, value),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                          decoration: _isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description.isNotEmpty
                            ? task.description
                            : 'Tidak ada deskripsi',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppSizes.fontSizeSmall,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progres berdasarkan status keseluruhan tugas.
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progres Pengerjaan',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Prioritas, kesulitan, dan jumlah subtask.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isUrgent
                        ? Colors.redAccent.withValues(alpha: 0.2)
                        : AppColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _isUrgent ? 'Urgent' : 'Normal',
                    style: TextStyle(
                      color: _isUrgent
                          ? Colors.redAccent
                          : AppColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.difficultyLevel.isNotEmpty
                        ? task.difficultyLevel
                        : 'Sedang',
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.checklist,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '0 Subtask',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
