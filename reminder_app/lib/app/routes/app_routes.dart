import 'package:flutter/material.dart';

// TODO (Nanti saat file layar asli dari tim sudah selesai):
// Hilangkan komentar import di bawah ini dan ganti Placeholder dengan Screen asli.
// import 'package:reminder_application_project/features/splash/splash_screen.dart';
// import 'package:reminder_application_project/features/auth/login_screen.dart';
// import 'package:reminder_application_project/features/auth/register_screen.dart';
// import 'package:reminder_application_project/features/dashboard/dashboard_screen.dart';
// import 'package:reminder_application_project/features/task/add_task_screen.dart';
// import 'package:reminder_application_project/features/task/edit_task_screen.dart';
// import 'package:reminder_application_project/features/task/task_detail_screen.dart';
// import 'package:reminder_application_project/features/history/history_screen.dart';
// import 'package:reminder_application_project/features/notification/notification_screen.dart';
// import 'package:reminder_application_project/features/profile/profile_screen.dart';

class AppRoutes {
  AppRoutes._(); // Private constructor

  // ===========================================================================
  // CONSTANT NAMA RUTE (Disepakati Bersama Tim)
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
          builder: (_) => const _PlaceholderScreen(title: 'Splash Screen (Aliyah)'),
          // Saat SplashScreen asli milik Aliyah siap:
          // builder: (_) => const SplashScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Login Screen (Laili)'),
          // builder: (_) => const LoginScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Register Screen (Laili)'),
          // builder: (_) => const RegisterScreen(),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Dashboard Screen (Aliyah)'),
          // builder: (_) => const DashboardScreen(),
        );

      case addTask:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Add Task Screen (Aliyah)'),
          // builder: (_) => const AddTaskScreen(),
        );

      case editTask:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Edit Task Screen (Aliyah)'),
          // builder: (_) => const EditTaskScreen(),
        );

      case taskDetail:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Task Detail Screen (Aliyah)'),
          // builder: (_) => const TaskDetailScreen(),
        );

      case history:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'History Screen (Laili)'),
          // builder: (_) => const HistoryScreen(),
        );

      case notification:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Notification Screen (Bintoro)'),
          // builder: (_) => const NotificationScreen(),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Profile Screen (Laili)'),
          // builder: (_) => const ProfileScreen(),
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
// PLACEHOLDER SCREEN SEMENTARA (DUMMY SCREEN)
// Kelas internal agar aplikasi tetap bisa dites jalan tanpa error/crash
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