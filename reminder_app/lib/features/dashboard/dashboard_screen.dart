import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app/routes/app_routes.dart';
import '../../services/task_service.dart';

import 'widgets/bar_aplikasi.dart';
import 'widgets/konten.dart';
import '../../core/widgets/interactive_nav_bar.dart';

// Layar utama dashboard aplikasi TaskZilla.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskService _taskService = TaskService();
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;
  String _selectedFilter = 'Semua';
  int _currentNavIndex = 0;
  final int _unreadNotificationCount = 0;
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

  // Memuat jumlah notifikasi belum dibaca dari service.
  Future<void> _loadUnreadNotificationCount() async {
    // TODO: Integrasi dengan NotificationService
  }

  // Menangani perpindahan tab navigasi bawah.
  void _handleNavTap(int index) {
    setState(() => _currentNavIndex = index);
    if (index == 1) Navigator.pushNamed(context, AppRoutes.addTask);
    if (index == 2) Navigator.pushNamed(context, AppRoutes.history);
    if (index == 3) Navigator.pushNamed(context, AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: DashboardAppBar(
        unreadNotificationCount: _unreadNotificationCount,
      ),
      body: DashboardContent(
        userId: _userId,
        taskService: _taskService,
        selectedFilter: _selectedFilter,
        searchController: _searchController,
        currentNavIndex: _currentNavIndex,
        onNavTap: _handleNavTap,
        onFilterChanged: (filter) {
          setState(() => _selectedFilter = filter);
        },
      ),
      bottomNavigationBar: InteractiveNavBar(
        currentIndex: _currentNavIndex,
        onTap: _handleNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
