import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/priority_calculator.dart';
import '../../../core/widgets/neu_card.dart';
import '../../../models/task_model.dart';
import '../../../services/task_service.dart';

/// Kartu tugas pada dashboard.
class TaskCardItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCardItem({super.key, required this.task, this.onTap});

  // ===========================================================================
  // DATA TURUNAN
  // ===========================================================================
  DateTime get _deadline => task.deadline.toDate();

  /// Status diseragamkan agar 'To Do', 'to-do', dan 'to_do' dianggap sama.
  String get _status {
    return task.status
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .trim()
        .toLowerCase();
  }

  bool get _isCompleted => _status == 'done' || _status == 'completed';

  bool get _isInProgress => _status == 'in progress';

  /// To Do = 0%, In Progress = 50%, Done = 100%.
  double get _progress {
    if (_isCompleted) return 1.0;
    if (_isInProgress) return 0.5;
    return 0.0;
  }

  /// Skor dihitung dari deadline, sama seperti halaman detail.
  int get _score => PriorityCalculator.calculateScore(_deadline);

  bool get _isUrgent => _score >= 80;

  Color get _priorityColor {
    if (_score >= 90) return AppColors.priorityUrgent;
    if (_score >= 80) return AppColors.priorityHigh;
    if (_score >= 60) return AppColors.priorityMedium;
    return AppColors.priorityLow;
  }

  String get _deadlineText {
    final day = _deadline.day.toString().padLeft(2, '0');
    final month = _deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${_deadline.year}';
  }

  // ===========================================================================
  // AKSI
  // ===========================================================================
  /// Menyimpan perubahan status tugas ke Firestore.
  Future<void> _toggleCompletion(BuildContext context, bool? value) async {
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
      status: value ? AppStrings.statusDone : AppStrings.statusTodo,
      createdAt: task.createdAt,
      updatedAt: Timestamp.now(),
    );

    try {
      await TaskService().updateTask(updatedTask);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.taskDetailStatusFailed}: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ===========================================================================
  // KOMPONEN KECIL
  // ===========================================================================
  Widget _badge({required String label, required Color color, IconData? icon}) {
    return Container(
      padding: AppSizes.badgePadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusBadge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.fontSizeXS, color: color),
            const SizedBox(width: AppSizes.spaceXS),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: AppSizes.fontSizeXS,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final deadlineColor = _isUrgent
        ? AppColors.priorityUrgent
        : AppColors.secondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: NeuCard(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori dan deadline.
            Row(
              children: [
                _badge(
                  label: task.categoryId.isNotEmpty
                      ? task.categoryId
                      : AppStrings.taskCardNoCategory,
                  color: AppColors.primary,
                ),
                const Spacer(),
                _badge(
                  label: _deadlineText,
                  color: deadlineColor,
                  icon: Icons.access_time,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceM),

            // Checkbox, judul, dan deskripsi.
            Row(
              children: [
                Checkbox(
                  value: _isCompleted,
                  activeColor: AppColors.primary,
                  checkColor: AppColors.textPrimary,
                  onChanged: (value) => _toggleCompletion(context, value),
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
                      const SizedBox(height: AppSizes.spaceXS),
                      Text(
                        task.description.isNotEmpty
                            ? task.description
                            : AppStrings.taskDetailNoDescription,
                        style: const TextStyle(
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

            const SizedBox(height: AppSizes.spaceM),

            // Progres berdasarkan status tugas.
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusBadge),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.taskCardProgressLabel,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppSizes.fontSizeXS,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: AppSizes.fontSizeXS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.spaceXS),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceM),

            // Prioritas dan tingkat kesulitan.
            Row(
              children: [
                _badge(
                  label: PriorityCalculator.getPriorityLabel(_deadline),
                  color: _priorityColor,
                  icon: Icons.flag_outlined,
                ),
                const SizedBox(width: AppSizes.spaceS),
                if (task.difficultyLevel.isNotEmpty)
                  _badge(
                    label: task.difficultyLevel,
                    color: AppColors.tertiary,
                    icon: Icons.speed_outlined,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
