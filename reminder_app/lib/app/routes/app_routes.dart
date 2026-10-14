import 'package:flutter/material.dart';

// Import layar milik Aliyah yang sudah selesai
import '../../features/splash/splash_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/task/add_task_screen.dart';
import '../../features/task/edit_task_screen.dart';
import '../../features/task/task_detail_screen.dart';

// Import layar dari tim yang sudah selesai
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/notification/notification_screen.dart';

// TODO(Laili): aktifkan import di bawah saat layarnya sudah jadi,
// lalu ganti _PlaceholderScreen di case history dan profile.
// import '../../features/history/history_screen.dart';
// import '../../features/profile/profile_screen.dart';

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
  // ARGUMEN RUTE
  // EditTaskScreen dan TaskDetailScreen butuh data awal. Kirim lewat:
  //   Navigator.pushNamed(context, AppRoutes.taskDetail, arguments: {
  //     'title': '...', 'description': '...', 'date': '...',
  //   });
  // Untuk editTask cukup 'title' dan 'description'.
  // ===========================================================================
  static Map<String, dynamic> _args(RouteSettings settings) {
    final a = settings.arguments;
    return a is Map<String, dynamic> ? a : const <String, dynamic>{};
  }

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
          builder: (_) => const LoginScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
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
        {
          final args = _args(settings);
          return MaterialPageRoute(
            builder: (_) => EditTaskScreen(
              initialTitle: args['title']?.toString() ?? '',
              initialDescription: args['description']?.toString() ?? '',
            ),
          );
        }

      case taskDetail:
        {
          final args = _args(settings);
          return MaterialPageRoute(
            builder: (_) => TaskDetailScreen(
              title: args['title']?.toString() ?? '',
              description: args['description']?.toString() ?? '',
              date: args['date']?.toString() ?? '',
            ),
          );
        }

      case history:
        return MaterialPageRoute(
          builder: (_) =>
              const _PlaceholderScreen(title: 'History Screen (Laili)'),
        );

      case notification:
        return MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) =>
              const _PlaceholderScreen(title: 'Profile Screen (Laili)'),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Rute Tidak Ditemukan')),
            body: Center(
              child: Text(
                  'Halaman dengan rute "${settings.name}" tidak ditemukan.'),
            ),
          ),
        );
    }
  }
}

// =============================================================================
// PLACEHOLDER SCREEN SEMENTARA UNTUK LAYAR YANG BELUM JADI
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