import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../services/task_service.dart';

import 'widgets/bar_aplikasi.dart';
import 'widgets/konten.dart';
import 'widgets/navigation_bar.dart';

// Layar utama dashboard aplikasi TaskZilla.
// Menampilkan ringkasan tugas, daftar tugas aktif, dan navigasi utama.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Service untuk mengelola data tugas
  final TaskService _taskService = TaskService();

  // ID pengguna yang sedang login
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // State untuk filter tugas yang dipilih
  String _selectedFilter = 'Semua';

  // State untuk navigasi bawah
  int _currentNavIndex = 0;

  // Jumlah notifikasi yang belum dibaca
  final int _unreadNotificationCount = 0;

  // Controller untuk search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUnreadNotificationCount();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Memuat jumlah notifikasi belum dibaca dari service
  Future<void> _loadUnreadNotificationCount() async {
    // TODO: Integrasi dengan NotificationService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(
        unreadNotificationCount: _unreadNotificationCount,
      ),
      body: DashboardContent(
        userId: _userId,
        taskService: _taskService,
        selectedFilter: _selectedFilter,
        searchController: _searchController,
        currentNavIndex: _currentNavIndex,
        onNavTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) Navigator.pushNamed(context, AppRoutes.addTask);
          if (index == 2) Navigator.pushNamed(context, AppRoutes.history);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.profile);
        },
        onFilterChanged: (filter) {
          setState(() => _selectedFilter = filter);
        },
      ),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) Navigator.pushNamed(context, AppRoutes.addTask);
          if (index == 2) Navigator.pushNamed(context, AppRoutes.history);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.profile);
        },
      ),
    );
  }
}
