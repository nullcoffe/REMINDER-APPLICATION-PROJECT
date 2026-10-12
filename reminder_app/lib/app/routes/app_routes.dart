import 'package:flutter/material.dart';

// Import layar milik Aliyah yang sudah selesai
import '../features/splash/splash_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/task/add_task_screen.dart';
import '../features/task/edit_task_screen.dart';
import '../features/task/task_detail_screen.dart';

// TODO (Nanti saat file layar dari tim lain selesai, aktifkan import di bawah):
// import '../features/auth/login_screen.dart';
// import '../features/auth/register_screen.dart';
// import '../features/history/history_screen.dart';
// import '../features/notification/notification_screen.dart';
// import '../features/profile/profile_screen.dart';

class AppRoutes {
  AppRoutes._(); // Private constructor

  // ===========================================================================
  // CONSTANT NAMA RUTE
  // ===========================================================================
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String taskDetail = '/task-detail';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String profile = '/profile';

  // Rute Awal Aplikasi
  static const String initialRoute = splash;

  // ===========================================================================
  // ROUTE GENERATOR GLOBAL
  // ===========================================================================
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Login Screen (Laili)'),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Register Screen (Laili)'),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case addTask:
        return MaterialPageRoute(
          builder: (_) => const AddTaskScreen(),
        );

      case editTask:
        // Sesuaikan parameter jika EditTaskScreen membutuhkan data awal
        return MaterialPageRoute(
          builder: (_) => const EditTaskScreen(),
        );

      case taskDetail:
        // Sesuaikan parameter jika TaskDetailScreen membutuhkan data awal
        return MaterialPageRoute(
          builder: (_) => const TaskDetailScreen(),
        );

      case history:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'History Screen (Laili)'),
        );

      case notification:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Notification Screen (Bintoro)'),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Profile Screen (Laili)'),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Rute Tidak Ditemukan')),
            body: Center(
              child: Text('Halaman dengan rute "${settings.name}" tidak ditemukan.'),
            ),
          ),
        );
    }
  }
}

// =============================================================================
// PLACEHOLDER SCREEN SEMENTARA UNTUK TIM LAIN
// =============================================================================
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              '$title\nsedang dalam tahap pengerjaan.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}