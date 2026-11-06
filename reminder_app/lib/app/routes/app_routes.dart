import 'package:flutter/material.dart';

// Import model data
import '../../models/task_model.dart';

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

  static const String initialRoute = splash;

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

      // Menerima objek TaskModel langsung
      case editTask:
        final task = settings.arguments as TaskModel;
        return MaterialPageRoute(
          builder: (_) => EditTaskScreen(task: task),
        );

      // Menerima objek TaskModel langsung
      case taskDetail:
        final task = settings.arguments as TaskModel;
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(task: task),
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
              child: Text('Halaman dengan rute "${settings.name}" tidak ditemukan.'),
            ),
          ),
        );
    }
  }
}