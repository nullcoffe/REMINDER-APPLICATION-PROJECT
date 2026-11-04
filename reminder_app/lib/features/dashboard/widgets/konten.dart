import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/task_model.dart';
import '../../../services/task_service.dart';

import 'sambutan.dart';
import 'pencarian.dart';
import 'card_item_tugas.dart';
import 'kosong.dart';
import 'summary_card.dart';
import 'filter_bar.dart';

class DashboardContent extends StatelessWidget {
  final String? userId;
  final TaskService taskService;
  final String selectedFilter;
  final TextEditingController searchController;
  final int currentNavIndex;
  final ValueChanged<int> onNavTap;
  final ValueChanged<String> onFilterChanged;

  const DashboardContent({
    super.key,
    required this.userId,
    required this.taskService,
    required this.selectedFilter,
    required this.searchController,
    required this.currentNavIndex,
    required this.onNavTap,
    required this.onFilterChanged,
  });

  String _normalizeStatus(dynamic status) {
    return status
        .toString()
        .split('.')
        .last
        .replaceAll('_', ' ')
        .trim()
        .toLowerCase();
  }

  List<TaskModel> _applyFilter(List<TaskModel> tasks, String filter) {
    switch (filter) {
      case 'To Do':
        return tasks.where((t) {
          final s = _normalizeStatus(t.status);
          return s == 'to do' || s == 'todo' || s == 'pending';
        }).toList();
      case 'In Progress':
        return tasks
            .where((t) => _normalizeStatus(t.status) == 'in progress')
            .toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: Text('Silakan login terlebih dahulu'));
    }

    return StreamBuilder<List<TaskModel>>(
      stream: taskService.getTasks(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<TaskModel> allTasks = snapshot.data ?? [];

        final activeTasks = allTasks.where((t) {
          final s = _normalizeStatus(t.status);
          return s != 'done' && s != 'completed';
        }).toList();

        final completedTasks = allTasks.where((t) {
          final s = _normalizeStatus(t.status);
          return s == 'done' || s == 'completed';
        }).toList();

        // Deadline dalam 3 hari ke depan (atau sudah lewat), hanya tugas aktif.
        final deadlineTasks = activeTasks.where((t) {
          try {
            final deadline = t.deadline.toDate();
            return deadline.difference(DateTime.now()).inDays <= 3;
          } catch (e) {
            return false;
          }
        }).toList();

        final filteredTasks = _applyFilter(activeTasks, selectedFilter);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingCard(),
              const SizedBox(height: AppSizes.spaceL),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Tugas Aktif',
                      value: activeTasks.length.toString(),
                      icon: Icons.assignment_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: SummaryCard(
                      title: 'Selesai',
                      value: completedTasks.length.toString(),
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: SummaryCard(
                      title: 'Deadline',
                      value: deadlineTasks.length.toString(),
                      icon: Icons.timer_outlined,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceL),
              SearchBarWidget(controller: searchController),
              const SizedBox(height: AppSizes.spaceL),
              FilterBar(
                selectedFilter: selectedFilter,
                onFilterChanged: onFilterChanged,
              ),
              const SizedBox(height: AppSizes.spaceL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Tugas Aktif',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: AppSizes.badgePadding,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusDefault,
                      ),
                    ),
                    child: Text(
                      '${filteredTasks.length} tugas',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSizes.fontSizeSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceM),
              if (filteredTasks.isEmpty)
                const EmptyStateWidget()
              else
                ...filteredTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
                    child: TaskCardItem(
                      task: task,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.taskDetail,
                          arguments: task,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
