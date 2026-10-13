
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/routes/app_routes.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_card.dart';
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
  /// Filter yang sedang dipilih pengguna.
  String _selectedFilter = 'Semua';

  /// Mengubah teks status menjadi format yang seragam.
  String _normalizeStatus(dynamic status) {
    return status.toString().split('.').last
        .replaceAll('_', ' ')
        .trim()
        .toLowerCase();
  }

  /// Memeriksa apakah tugas sesuai dengan filter.
  bool _matchesFilter(dynamic task) {
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

    // Jika deadline berupa DateTime, format tanggalnya.
    if (deadline is DateTime) {
      final day = deadline.day.toString().padLeft(2, '0');
      final month = deadline.month.toString().padLeft(2, '0');
      final year = deadline.year;

      return '$day/$month/$year';
    }

    // Jika deadline sudah berupa String, gunakan nilai tersebut.
    return deadline.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil daftar tugas dari Provider.
    // Perubahan data akan membuat dashboard diperbarui.
    final taskProvider = context.watch<TaskProvider>();
    final List<dynamic> allTasks = taskProvider.tasks;

    // Memisahkan tugas berdasarkan status.
    final filteredTasks = allTasks
        .where((task) => _matchesFilter(task))
        .toList();

    final totalTasks = allTasks.length;

    final completedTasks = allTasks.where((task) {
      return _normalizeStatus(task.status) == 'done';
    }).length;

    final todoTasks = allTasks.where((task) {
      return _normalizeStatus(task.status) == 'to do';
    }).length;

    final inProgressTasks = allTasks.where((task) {
      return _normalizeStatus(task.status) == 'in progress';
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskZilla',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sapaan dan pengantar halaman dashboard.
              const Text(
                'Halo, selamat datang!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Yuk, atur tugasmu agar lebih terorganisir.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              // Judul bagian ringkasan.
              const Text(
                'Ringkasan Tugas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Kartu ringkasan menggunakan SummaryCard.
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Semua Tugas',
                      value: totalTasks.toString(),
                      icon: Icons.assignment_outlined,
                      color: Colors.teal,
                    ),
                  ),

                  const SizedBox(width: 12),

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

              const SizedBox(height: 12),

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

                  const SizedBox(width: 12),

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

              const SizedBox(height: 28),

              // Judul bagian daftar tugas.
              const Text(
                'Daftar Tugas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // FilterBar hanya mengatur filter yang dipilih.
              // Penyaringan daftar dilakukan oleh dashboard.
              FilterBar(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Menampilkan pesan jika belum ada tugas.
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

                        const SizedBox(height: 12),

                        Text(
                          totalTasks == 0
                              ? 'Belum ada tugas.'
                              : 'Tidak ada tugas pada filter ini.',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Tambahkan tugas agar aktivitasmu lebih teratur.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Setiap tugas ditampilkan menggunakan TaskCard.
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTasks.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];

                    return TaskCard(
                      title: task.title.toString(),
                      category: task.category.toString(),
                      priority: task.priority.toString(),
                      deadline: _formatDeadline(task.deadline),

                      // Membuka halaman detail dengan membawa data tugas.
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
      ),

      // Tombol untuk membuka halaman tambah tugas.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addTask);
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),
    );
  }
}
