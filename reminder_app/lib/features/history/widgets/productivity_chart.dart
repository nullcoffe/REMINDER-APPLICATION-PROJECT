import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/task_model.dart';

// Grafik batang yang menghitung data tugas selesai 7 hari terakhir
class ProductivityChart extends StatelessWidget {
  final List<TaskModel> completedTasks;

  const ProductivityChart({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final Map<int, int> tasksPerDay = {};

    // Inisialisasi 7 hari terakhir
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      tasksPerDay[date.weekday] = 0;
    }

    // Hitung tugas yang selesai per hari berdasarkan updatedAt
    for (var task in completedTasks) {
      if (task.updatedAt != null) {
        final completedDate = task.updatedAt!.toDate();
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          if (completedDate.year == date.year &&
              completedDate.month == date.month &&
              completedDate.day == date.day) {
            tasksPerDay[completedDate.weekday] =
                (tasksPerDay[completedDate.weekday] ?? 0) + 1;
          }
        }
      }
    }

    // Cari nilai maksimal untuk skala tinggi batang
    final maxTasks = tasksPerDay.values.fold(
      0,
      (max, count) => count > max ? count : max,
    );
    final double maxBarHeight = 80.0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produktivitas 7 Hari Terakhir',
            style: TextStyle(
              fontSize: AppSizes.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '${completedTasks.length} tugas total diselesaikan',
            style: TextStyle(
              fontSize: AppSizes.fontSizeSmall,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tasksPerDay.entries.map((entry) {
                final day = entry.key;
                final count = entry.value;
                final barHeight = maxTasks == 0
                    ? 2.0
                    : (count / maxTasks) * maxBarHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 12,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDayName(day),
                      style: TextStyle(
                        fontSize: 10,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }
}