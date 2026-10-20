import 'package:flutter/material.dart';

// Import fitur autentikasi
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';

// Import fitur utama aplikasi
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/notification/notification_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/task/add_task_screen.dart';
import '../../features/task/edit_task_screen.dart';
import '../../features/task/task_detail_screen.dart';

/// Kelas untuk mengelola routing aplikasi.
/// Berisi konstanta nama rute dan generator rute global.
class AppRoutes {
  AppRoutes._();

  // Konstanta nama rute
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String taskDetail = '/task-detail';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String profile = '/profile';

  /// Rute awal yang dijalankan saat aplikasi dibuka.
  static const String initialRoute = splash;

  /// Helper untuk mengekstrak argumen dari RouteSettings.
  /// Mengembalikan Map kosong jika argumen tidak ada atau bukan Map.
  static Map<String, dynamic> _args(RouteSettings settings) {
    final arguments = settings.arguments;
    return arguments is Map<String, dynamic>
        ? arguments
        : const <String, dynamic>{};
  }

  /// Generator rute global untuk MaterialApp.
  /// Menangani navigasi ke setiap layar berdasarkan nama rute.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());

      case editTask:
        final args = _args(settings);
        return MaterialPageRoute(
          builder: (_) => EditTaskScreen(
            initialTitle: args['title']?.toString() ?? '',
            initialDescription: args['description']?.toString() ?? '',
          ),
        );

      case taskDetail:
        final args = _args(settings);
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(
            title: args['title']?.toString() ?? '',
            description: args['description']?.toString() ?? '',
            date: args['date']?.toString() ?? '',
          ),
        );

      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());

      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Rute Tidak Ditemukan')),
            body: Center(
              child: Text(
                'Halaman dengan rute "${settings.name}" tidak ditemukan.',
              ),
            ),
          ),
        );
    }
  }
}
