
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app/routes/app_routes.dart';
import '../../services/task_service.dart';
import '../../services/notification_service.dart';

import 'widgets/bar_aplikasi.dart';
import 'widgets/konten.dart';
import '../../core/widgets/interactive_nav_bar.dart';

// Layar utama dashboard aplikasi TaskZilla.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final TaskService _taskService = TaskService();
  final NotificationService _notificationService =
      NotificationService();

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  String _selectedFilter = 'Semua';
  int _currentNavIndex = 0;
  int _unreadNotificationCount = 0;

  final TextEditingController _searchController =
      TextEditingController();

  StreamSubscription<int>? _unreadNotificationSubscription;

  bool _isCheckingDeadlineReminders = false;

  @override
  void initState() {
    super.initState();

    // Memantau perubahan status aplikasi.
    WidgetsBinding.instance.addObserver(this);

    // Memuat jumlah notifikasi belum dibaca.
    _loadUnreadNotificationCount();

    // Memeriksa deadline ketika Dashboard pertama kali dibuka.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_checkDeadlineReminders());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // Menghentikan listener Firestore.
    final subscription = _unreadNotificationSubscription;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }

    _searchController.dispose();

    super.dispose();
  }

  // Memeriksa kembali deadline ketika aplikasi aktif.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_checkDeadlineReminders());
    }
  }

  // Memuat jumlah notifikasi belum dibaca dari Firestore.
  void _loadUnreadNotificationCount() {
    final userId = _userId;

    if (userId == null) return;

    _unreadNotificationSubscription =
        _notificationService.getUnreadCount(userId).listen(
      (count) {
        if (!mounted) return;

        setState(() {
          _unreadNotificationCount = count;
        });
      },
      onError: (Object error) {
        debugPrint(
          'Gagal memuat jumlah notifikasi: $error',
        );
      },
    );
  }

  // Memeriksa deadline dan menyimpan pengingat yang sudah waktunya.
  Future<void> _checkDeadlineReminders() async {
    final userId = _userId;

    if (userId == null || _isCheckingDeadlineReminders) {
      return;
    }

    _isCheckingDeadlineReminders = true;

    try {
      final createdCount =
          await _notificationService.checkAndCreateDueReminders(
        userId: userId,
      );

      if (!mounted || createdCount == 0) return;

      // Memberikan informasi bahwa ada pengingat baru.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$createdCount pengingat deadline baru tersedia.',
          ),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Lihat',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.notification,
              );
            },
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Gagal memeriksa deadline: $error',
      );
      debugPrint('$stackTrace');
    } finally {
      _isCheckingDeadlineReminders = false;
    }
  }

  // Navigasi dan pemeriksaan ulang setelah kembali ke Dashboard.
  Future<void> _navigateAndRefresh(String routeName) async {
    await Navigator.pushNamed(context, routeName);

    if (!mounted) return;

    await _checkDeadlineReminders();
  }

  // Menangani perpindahan tab navigasi bawah.
  void _handleNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    if (index == 1) {
      unawaited(_navigateAndRefresh(AppRoutes.addTask));
    } else if (index == 2) {
      unawaited(_navigateAndRefresh(AppRoutes.history));
    } else if (index == 3) {
      unawaited(_navigateAndRefresh(AppRoutes.profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
          setState(() {
            _selectedFilter = filter;
          });
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
