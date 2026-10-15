import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/task_service.dart';
import '../../models/task_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'widgets/completed_task_card.dart';

// Layar utama untuk menampilkan riwayat tugas yang telah diselesaikan
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TaskService _taskService = TaskService();
  // Mengambil ID pengguna yang sedang login dari Firebase Auth
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Tugas'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: _userId == null
          ? const Center(child: Text('Silakan login terlebih dahulu'))
          : StreamBuilder<List<TaskModel>>(
              // Mengambil stream data tugas dari Firestore berdasarkan userId
              stream: _taskService.getTasks(_userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allTasks = snapshot.data ?? [];
                // Memfilter hanya tugas yang berstatus 'completed'
                final completedTasks = allTasks
                    .where((task) => task.status == 'completed')
                    .toList();

                // Menampilkan empty state jika tidak ada tugas selesai
                if (completedTasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: AppSizes.spaceM),
                        const Text('Belum ada tugas yang diselesaikan.'),
                      ],
                    ),
                  );
                }

                // Merender daftar kartu tugas yang sudah selesai
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.pagePadding),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    return CompletedTaskCard(task: completedTasks[index]);
                  },
                );
              },
            ),
    );
  }
}
