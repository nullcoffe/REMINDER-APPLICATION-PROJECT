import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/task_service.dart';
import '../../models/task_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TaskService _taskService = TaskService();

  // Ambil userId dari Firebase Auth langsung
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
              stream: _taskService.getTasks(_userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allTasks = snapshot.data ?? [];
                //ini menentukan bagian tugas kategori mana yang di tampilkan dihistori
                final completedTasks = allTasks
                    .where((task) => task.status == 'completed')
                    .toList();

                if (completedTasks.isEmpty) {
                  return const Center(
                    child: Text('Belum ada tugas yang diselesaikan.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.spaceL),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.description),
                        trailing: Text(task.difficultyLevel),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
