import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app/routes/app_routes.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import 'widgets/completed_task_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TaskService _taskService = TaskService();
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _confirmAndDelete(TaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _taskService.permanentDeleteTask(task.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tugas berhasil dihapus')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_userId == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(title: const Text('Riwayat Tugas')),
        body: const Center(child: Text('Silakan login terlebih dahulu')),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Riwayat Tugas'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _taskService.getCompletedTasks(_userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final completedTasks = snapshot.data ?? [];

          if (completedTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada tugas yang diselesaikan.',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return CompletedTaskCard(
                task: task,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.taskDetail,
                    arguments: task,
                  );
                },
                onDelete: () => _confirmAndDelete(task),
              );
            },
          );
        },
      ),
    );
  }
}
