
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Memastikan Flutter siap sebelum Firebase dijalankan.
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Firebase sesuai platform.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Menjalankan aplikasi Reminder App.
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nama aplikasi.
      title: 'Reminder App',

      // Menyembunyikan banner DEBUG.
      debugShowCheckedModeBanner: false,

      // Menggunakan tema dari AppTheme.
      theme: AppTheme.lightTheme,

      // Menentukan halaman pertama aplikasi.
      initialRoute: AppRoutes.initialRoute,

      // Menghubungkan navigasi dengan AppRoutes.
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
