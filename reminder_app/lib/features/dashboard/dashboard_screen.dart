import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app/routes/app_routes.dart';
import '../../services/task_service.dart';
import '../../models/task_model.dart';
import '../../core/widgets/task_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'widgets/filter_bar.dart';
import 'widgets/summary_card.dart';

/// Halaman utama TaskZilla.
/// Menampilkan ringkasan dan daftar tugas pengguna.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskService _taskService = TaskService();
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Filter yang sedang dipilih pengguna.
  String _selectedFilter = 'Semua';

  /// Mengubah teks status menjadi format yang seragam.
  String _normalizeStatus(dynamic status) {
    return status
        .toString()
        .split('.')
        .last
        .replaceAll('_', ' ')
        .trim()
        .toLowerCase();
  }

  /// Memeriksa apakah tugas sesuai dengan filter.
  bool _matchesFilter(TaskModel task) {
    if (_selectedFilter == 'Semua') {
      return true;
    }

    final status = _normalizeStatus(task.status);
    final filter = _selectedFilter.toLowerCase();

    return status == filter;
  }

  /// Mengubah nilai deadline menjadi teks yang dapat ditampilkan.
  String _formatDeadline(dynamic deadline) {
    if (deadline == null) {
      return 'Deadline belum ditentukan';
    }

    if (deadline is DateTime) {
      final day = deadline.day.toString().padLeft(2, '0');
      final month = deadline.month.toString().padLeft(2, '0');
      final year = deadline.year;

      return '$day/$month/$year';
    }

    return deadline.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskZilla',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
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

                final List<TaskModel> allTasks = snapshot.data ?? [];

                final filteredTasks = allTasks
                    .where((task) => _matchesFilter(task))
                    .toList();

                final totalTasks = allTasks.length;

                final completedTasks = allTasks.where((task) {
                  return _normalizeStatus(task.status) == 'done' ||
                      _normalizeStatus(task.status) == 'completed';
                }).length;

                final todoTasks = allTasks.where((task) {
                  return _normalizeStatus(task.status) == 'to do' ||
                      _normalizeStatus(task.status) == 'todo';
                }).length;

                final inProgressTasks = allTasks.where((task) {
                  return _normalizeStatus(task.status) == 'in progress';
                }).length;

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSizes.pagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo, selamat datang!',
                          style: TextStyle(
                            fontSize: AppSizes.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceXS),
                        const Text(
                          'Yuk, atur tugasmu agar lebih terorganisir.',
                          style: TextStyle(
                            fontSize: AppSizes.fontSizeSmall,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceL),
                        const Text(
                          'Ringkasan Tugas',
                          style: TextStyle(
                            fontSize: AppSizes.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceS),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Semua Tugas',
                                value: totalTasks.toString(),
                                icon: Icons.assignment_outlined,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceS),
                            Expanded(
                              child: SummaryCard(
                                title: 'Tugas Selesai',
                                value: completedTasks.toString(),
                                icon: Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spaceS),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Belum Dikerjakan',
                                value: todoTasks.toString(),
                                icon: Icons.pending_actions,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceS),
                            Expanded(
                              child: SummaryCard(
                                title: 'Sedang Dikerjakan',
                                value: inProgressTasks.toString(),
                                icon: Icons.autorenew,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spaceXL),
                        const Text(
                          'Daftar Tugas',
                          style: TextStyle(
                            fontSize: AppSizes.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceS),
                        FilterBar(
                          selectedFilter: _selectedFilter,
                          onFilterChanged: (filter) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        if (filteredTasks.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.assignment_outlined,
                                    size: 52,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: AppSizes.spaceS),
                                  Text(
                                    totalTasks == 0
                                        ? 'Belum ada tugas.'
                                        : 'Tidak ada tugas pada filter ini.',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: AppSizes.fontSizeSmall,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.spaceXS),
                                  const Text(
                                    'Tambahkan tugas agar aktivitasmu lebih teratur.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSizeXS,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredTasks.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: AppSizes.spaceS);
                            },
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];

                              return TaskCard(
                                title: task.title,
                                category: task.categoryId,
                                priority: task.priorityScore.toString(),
                                deadline: _formatDeadline(task.deadline),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.taskDetail,
                                    arguments: task,
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addTask);
        },
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),
    );
  }
}
