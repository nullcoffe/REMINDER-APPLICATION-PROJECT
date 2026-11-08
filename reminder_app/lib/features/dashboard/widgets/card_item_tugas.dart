import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/priority_calculator.dart';
import '../../../core/widgets/neu_card.dart';
import '../../../models/task_model.dart';
import '../../../services/task_service.dart';

<<<<<<< HEAD
// Widget kartu tugas dengan animasi skala saat ditekan.
=======
/// Kartu tugas pada dashboard.
>>>>>>> develop
class TaskCardItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCardItem({super.key, required this.task, this.onTap});

<<<<<<< HEAD
  bool get _isUrgent => task.priorityScore >= 80;
=======
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
>>>>>>> develop

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
<<<<<<< HEAD
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      splashColor: colorScheme.primary.withValues(alpha: 0.1),
=======
    final deadlineColor = _isUrgent
        ? AppColors.priorityUrgent
        : AppColors.secondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
>>>>>>> develop
      child: NeuCard(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori dan deadline.
            Row(
              children: [
<<<<<<< HEAD
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.categoryId.isNotEmpty ? task.categoryId : 'Umum',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
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
                        ? colorScheme.errorContainer
                        : colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: _isUrgent
                            ? colorScheme.error
                            : colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _deadlineText,
                        style: TextStyle(
                          color: _isUrgent
                              ? colorScheme.error
                              : colorScheme.secondary,
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
            // Judul dan Deskripsi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: AppSizes.fontSizeMedium,
                    fontWeight: FontWeight.bold,
=======
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
>>>>>>> develop
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description.isNotEmpty
                      ? task.description
                      : 'Tidak ada deskripsi',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: AppSizes.fontSizeSmall,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
<<<<<<< HEAD
            const SizedBox(height: 12),
            // Progress bar
=======

            const SizedBox(height: AppSizes.spaceM),

            // Progres berdasarkan status tugas.
>>>>>>> develop
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
=======
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusBadge),
>>>>>>> develop
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.taskCardProgressLabel,
                        style: TextStyle(
<<<<<<< HEAD
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '0%',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
=======
                          color: AppColors.textSecondary,
                          fontSize: AppSizes.fontSizeXS,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: AppSizes.fontSizeXS,
>>>>>>> develop
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.spaceXS),
                    child: LinearProgressIndicator(
<<<<<<< HEAD
                      value: 0,
                      backgroundColor: colorScheme.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
=======
                      value: _progress,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
>>>>>>> develop
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
<<<<<<< HEAD
            const SizedBox(height: 12),
            // Baris bawah: Prioritas, Kesulitan, Subtask
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isUrgent
                        ? colorScheme.errorContainer
                        : colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _isUrgent ? 'Urgent' : 'Normal',
                    style: TextStyle(
                      color: _isUrgent
                          ? colorScheme.error
                          : colorScheme.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
=======

            const SizedBox(height: AppSizes.spaceM),

            // Prioritas dan tingkat kesulitan.
            Row(
              children: [
                _badge(
                  label: PriorityCalculator.getPriorityLabel(_deadline),
                  color: _priorityColor,
                  icon: Icons.flag_outlined,
>>>>>>> develop
                ),
                const SizedBox(width: AppSizes.spaceS),
                if (task.difficultyLevel.isNotEmpty)
                  _badge(
                    label: task.difficultyLevel,
                    color: AppColors.tertiary,
                    icon: Icons.speed_outlined,
                  ),
<<<<<<< HEAD
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.difficultyLevel.isNotEmpty
                        ? task.difficultyLevel
                        : 'Sedang',
                    style: TextStyle(
                      color: colorScheme.onTertiaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.checklist,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '0 Subtask',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
=======
>>>>>>> develop
              ],
            ),
          ],
        ),
      ),
    );
  }
}
