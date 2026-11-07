import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/neu_card.dart';
import '../../../models/task_model.dart';

// Widget untuk menampilkan satu kartu tugas di dashboard.
class TaskCardItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCardItem({super.key, required this.task, this.onTap});

  // Menentukan apakah tugas bersifat urgent berdasarkan skor prioritas.
  bool get _isUrgent => task.priorityScore >= 80;

  // Memformat Timestamp deadline menjadi teks tanggal yang mudah dibaca.
  String get _deadlineText {
    try {
      final DateTime date = task.deadline.toDate();
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      return '$day/$month/$year';
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil skema warna dari tema aktif.
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: NeuCard(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: Kategori dan Deadline
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isUrgent ? colorScheme.errorContainer : colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: _isUrgent ? colorScheme.error : colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _deadlineText,
                        style: TextStyle(
                          color: _isUrgent ? colorScheme.error : colorScheme.secondary,
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

            // Baris tengah: Checkbox, Judul, dan Deskripsi
            Row(
              children: [
                Checkbox(
                  value: false,
                  activeColor: colorScheme.primary,
                  checkColor: colorScheme.onPrimary,
                  side: BorderSide(color: colorScheme.outline),
                  onChanged: (value) {},
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description.isNotEmpty ? task.description : 'Tidak ada deskripsi',
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
            const SizedBox(height: 12),

            // Bagian Progress Pengerjaan
            Container(
              padding: const EdgeInsets.all(12),
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
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                      ),
                      Text(
                        '0%',
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
                      value: 0,
                      backgroundColor: colorScheme.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Baris bawah: Prioritas, Kesulitan, dan Subtask
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isUrgent ? colorScheme.errorContainer : colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _isUrgent ? 'Urgent' : 'Normal',
                    style: TextStyle(
                      color: _isUrgent ? colorScheme.error : colorScheme.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.difficultyLevel.isNotEmpty ? task.difficultyLevel : 'Sedang',
                    style: TextStyle(
                      color: colorScheme.onTertiaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.checklist, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  '0 Subtask',
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}