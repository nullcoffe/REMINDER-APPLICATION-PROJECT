import 'package:flutter/material.dart';

// =============================================================================
// IMPORTS (Layanan / Screen Asli)
// Un-comment (hapus tanda //) baris import di bawah ini jika file screen teman Anda sudah dibuat.
// =============================================================================
// import '../../features/splash/splash_screen.dart';        // Aliyah
// import '../../features/auth/login_screen.dart';          // Laili
// import '../../features/dashboard/dashboard_screen.dart';  // Aliyah
// import '../../features/task/task_detail_screen.dart';    // Aliyah + Laudya
// import '../../features/history/history_screen.dart';      // Laili
// import '../../features/notification/notification_screen.dart'; // Bintoro
// import '../../features/profile/profile_screen.dart';      // Laili

class AppRoutes {
  // ---------------------------------------------------------------------------
  // 1. CONSTANTS NAMA RUTE (Digunakan oleh seluruh anggota tim)
  // ---------------------------------------------------------------------------
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String taskDetail = '/task-detail';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String profile = '/profile';

  // ---------------------------------------------------------------------------
  // 2. TOGGLE FITUR (Feature Flags)
  // Ubah ke `true` jika fitur/layar dari teman tim sudah siap diuji.
  // Ini mencegah crash saat aplikasi dijalankan oleh tim lain.
  // ---------------------------------------------------------------------------
  static const bool _useRealSplash = false;       // Aliyah
  static const bool _useRealLogin = false;        // Laili
  static const bool _useRealDashboard = false;    // Aliyah
  static const bool _useRealTaskDetail = false;   // Aliyah + Laudya
  static const bool _useRealHistory = false;      // Laili
  static const bool _useRealNotification = false; // Bintoro
  static const bool _useRealProfile = false;      // Laili

  // ---------------------------------------------------------------------------
  // 3. GENERATE ROUTE
  // ---------------------------------------------------------------------------
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => _useRealSplash
              ? const SizedBox() // Ganti dengan: const SplashScreen()
              : const _PlaceholderScreen(title: 'Splash Screen', assignee: 'Aliyah'),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => _useRealLogin
              ? const SizedBox() // Ganti dengan: const LoginScreen()
              : const _PlaceholderScreen(title: 'Login Screen', assignee: 'Laili'),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => _useRealDashboard
              ? const SizedBox() // Ganti dengan: const DashboardScreen()
              : const _PlaceholderScreen(title: 'Dashboard Screen', assignee: 'Aliyah'),
        );

      case taskDetail:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => _useRealTaskDetail
              ? const SizedBox() // Ganti dengan: TaskDetailScreen(task: args)
              : _PlaceholderScreen(
                  title: 'Task Detail Screen',
                  assignee: 'Aliyah + Laudya',
                  extraData: args,
                ),
        );

      case history:
        return MaterialPageRoute(
          builder: (_) => _useRealHistory
              ? const SizedBox() // Ganti dengan: const HistoryScreen()
              : const _PlaceholderScreen(title: 'History Screen', assignee: 'Laili'),
        );

      case notification:
        return MaterialPageRoute(
          builder: (_) => _useRealNotification
              ? const SizedBox() // Ganti dengan: const NotificationScreen()
              : const _PlaceholderScreen(title: 'Notification Screen', assignee: 'Bintoro'),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => _useRealProfile
              ? const SizedBox() // Ganti dengan: const ProfileScreen()
              : const _PlaceholderScreen(title: 'Profile Screen', assignee: 'Laili'),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Rute Tidak Ditemukan')),
            body: Center(
              child: Text('Rute "${settings.name}" belum terdaftar di AppRoutes.'),
            ),
          ),
        );
    }
  }
}

// =============================================================================
// 4. SCREEN PLACEHOLDER (Satu-satunya komponen internal isolasi)
// Digunakan agar aplikasi tetap bisa berpindah halaman tanpa crash saat
// fitur teman belum selesai dikerjakan.
// =============================================================================
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String assignee;
  final dynamic extraData;

  const _PlaceholderScreen({
    required this.title,
    required this.assignee,
    this.extraData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction_rounded,
                size: 72,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  'Penanggung Jawab: $assignee',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (extraData != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Arguments / Data Diterima:\n$extraData',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}