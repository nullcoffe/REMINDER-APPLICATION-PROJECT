import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/task_model.dart';
import '../../models/checklist_model.dart';
import '../../services/checklist_service.dart';

// Layar detail tugas dengan stepper, sub-tugas, dan tombol edit.
class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final ChecklistService _checklistService = ChecklistService();

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getPriorityLabel(int score) {
    if (score >= 80) return 'Urgent';
    if (score >= 60) return 'Tinggi';
    if (score >= 40) return 'Sedang';
    return 'Rendah';
  }

  Color _getPriorityColor(int score) {
    if (score >= 80) return Colors.red;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.blue;
    return Colors.grey;
  }

  // Menghitung progres sub-tugas.
  int _calculateProgress(List<ChecklistModel> items) {
    if (items.isEmpty) return 0;
    final completed = items.where((i) => i.isCompleted).length;
    return (completed / items.length * 100).round();
  }

  // Toggle status sub-tugas.
  Future<void> _toggleSubTask(ChecklistModel item) async {
    final updated = item.copyWith(
      isCompleted: !item.isCompleted,
      updatedAt: Timestamp.now(),
    );
    await _checklistService.updateChecklist(updated);
  }

  // Tandai tugas sebagai selesai.
  Future<void> _markAsDone() async {
    final updated = widget.task.copyWith(
      status: AppStrings.statusDone,
      updatedAt: Timestamp.now(),
    );
    // TODO: panggil taskService.updateTask(updated)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas ditandai selesai!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final task = widget.task;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: colorScheme.error),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: colorScheme.surface,
                  title: Text(
                    'Hapus Tugas',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  content: Text(
                    'Yakin ingin menghapus tugas ini?',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        // TODO: panggil taskService.deleteTask(task.id)
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChecklistModel>>(
        stream: _checklistService.getChecklist(task.id),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          final progress = _calculateProgress(items);
          final completedCount = items.where((i) => i.isCompleted).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge kategori dan prioritas
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.categoryId.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priorityScore)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Prioritas ${_getPriorityLabel(task.priorityScore)}',
                        style: TextStyle(
                          color: _getPriorityColor(task.priorityScore),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Judul tugas
                Text(
                  task.title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Badge kesulitan
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.difficultyLevel.isNotEmpty
                        ? task.difficultyLevel
                        : 'Sedang',
                    style: TextStyle(
                      color: colorScheme.onTertiaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Smart Alarm & Deadline
                Row(
                  children: [
                    Icon(Icons.alarm, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Sisa Waktu Pengerjaan',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Deadline: ${_formatDate(task.deadline.toDate())}',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // Stepper pengerjaan
                Text(
                  'Tahapan Pengerjaan',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStepItem(
                            context,
                            'To Do',
                            0,
                            progress,
                            colorScheme,
                          ),
                          _buildStepItem(
                            context,
                            'In Progress',
                            1,
                            progress,
                            colorScheme,
                          ),
                          _buildStepItem(
                            context,
                            'Done',
                            2,
                            progress,
                            colorScheme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Deskripsi tugas
                Text(
                  'Deskripsi Tugas',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description.isNotEmpty
                      ? task.description
                      : 'Tidak ada deskripsi',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Daftar sub-tugas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Sub-tugas',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$completedCount dari ${items.length} selesai (${progress}%)',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      ...items.map(
                        (item) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: Checkbox(
                            value: item.isCompleted,
                            activeColor: colorScheme.primary,
                            side: BorderSide(color: colorScheme.outline),
                            onChanged: (_) => _toggleSubTask(item),
                          ),
                          title: Text(
                            item.itemTitle,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Belum ada sub-tugas',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      // Tombol aksi di bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editTask,
                      arguments: task,
                    );
                  },
                  icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                  label: Text(
                    'Edit Tugas',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _markAsDone,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Tandai Selesai'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk setiap step di stepper.
  Widget _buildStepItem(
    BuildContext context,
    String label,
    int stepIndex,
    int progress,
    ColorScheme colorScheme,
  ) {
    final isCompleted = progress > (stepIndex * 50);
    final isCurrent = !isCompleted && progress > ((stepIndex - 1) * 50);

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? colorScheme.primary
                : (isCurrent
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceVariant),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle_outlined,
            color: isCompleted
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted || isCurrent
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: (isCompleted || isCurrent)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
