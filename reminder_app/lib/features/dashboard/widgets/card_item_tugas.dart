import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/priority_calculator.dart';
import '../../../core/widgets/neu_card.dart';
import '../../../models/task_model.dart';
import '../../../services/task_service.dart';

/// Kartu tugas pada dashboard dengan animasi tap dan toggle completion.
class TaskCardItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCardItem({super.key, required this.task, this.onTap});

  // Properti turunan
  DateTime get _deadline => task.deadline.toDate();

  /// Menyeragamkan format status dari Firestore.
  String get _status {
    return task.status
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .trim()
        .toLowerCase();
  }

  /// Memeriksa apakah tugas sudah selesai.
  bool get _isCompleted => _status == 'done' || _status == 'completed';

  /// Memeriksa apakah tugas sedang dikerjakan.
  bool get _isInProgress => _status == 'in progress';

  /// Menghitung persentase progres berdasarkan status.
  double get _progress {
    if (_isCompleted) return 1.0;
    if (_isInProgress) return 0.5;
    return 0.0;
  }

  /// Menghitung skor prioritas berdasarkan deadline.
  int get _score => PriorityCalculator.calculateScore(_deadline);

  /// Memeriksa apakah prioritas bersifat mendesak.
  bool get _isUrgent => _score >= 80;

  /// Memformat tanggal deadline menjadi format DD/MM/YYYY.
  String get _deadlineText {
    final day = _deadline.day.toString().padLeft(2, '0');
    final month = _deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${_deadline.year}';
  }

  /// Mengembalikan warna prioritas berdasarkan skor.
  Color _getPriorityColor(int score, ColorScheme colorScheme) {
    if (score >= 80) return colorScheme.error;
    if (score >= 60) return colorScheme.primary;
    if (score >= 40) return colorScheme.secondary;
    return colorScheme.tertiary;
  }

  /// Mengembalikan label teks prioritas berdasarkan skor.
  String _getPriorityLabel(int score) {
    if (score >= 80) return 'Urgent';
    if (score >= 60) return 'Tinggi';
    if (score >= 40) return 'Sedang';
    return 'Rendah';
  }

  // Metode aksi
  /// Mengubah status penyelesaian tugas di Firestore.
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
          content: Text('Gagal mengubah status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Widget pembantu
  /// Membuat badge label dengan ikon opsional.
  Widget _badge({
    required String label,
    required Color color,
    required ColorScheme colorScheme,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Antarmuka pengguna
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priorityColor = _getPriorityColor(_score, colorScheme);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      splashColor: colorScheme.primary.withValues(alpha: 0.1),
      child: NeuCard(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori dan deadline
            Row(
              children: [
                _badge(
                  label: task.categoryId.isNotEmpty ? task.categoryId : 'Umum',
                  color: colorScheme.primary,
                  colorScheme: colorScheme,
                ),
                const Spacer(),
                _badge(
                  label: _deadlineText,
                  color: _isUrgent ? colorScheme.error : colorScheme.secondary,
                  colorScheme: colorScheme,
                  icon: Icons.access_time,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),

            // Checkbox, judul, dan deskripsi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isCompleted,
                  activeColor: colorScheme.primary,
                  checkColor: colorScheme.onPrimary,
                  side: BorderSide(color: colorScheme.outline),
                  onChanged: (value) => _toggleCompletion(context, value),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: colorScheme.onSurface,
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
                          color: colorScheme.onSurfaceVariant,
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

            // Progres berdasarkan status tugas
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
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
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).round()}%',
                        style: TextStyle(
                          color: colorScheme.primary,
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
                      value: _progress,
                      backgroundColor: colorScheme.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),

            // Prioritas, kesulitan, dan subtask
            Row(
              children: [
                _badge(
                  label: _getPriorityLabel(_score),
                  color: priorityColor,
                  colorScheme: colorScheme,
                  icon: Icons.flag_outlined,
                ),
                const SizedBox(width: 8),
                if (task.difficultyLevel.isNotEmpty)
                  _badge(
                    label: task.difficultyLevel,
                    color: colorScheme.tertiary,
                    colorScheme: colorScheme,
                    icon: Icons.speed_outlined,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}