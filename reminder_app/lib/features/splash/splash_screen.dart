import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/routes/app_routes.dart';

/// Splash Screen TaskZilla.
///
/// Halaman ini tampil pertama kali ketika aplikasi dibuka.
/// Setelah 3 detik, pengguna diarahkan ke halaman Login.
///
/// Catatan:
/// Pastikan AppRoutes.login tersedia di file app_routes.dart.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Menyimpan timer agar bisa dibatalkan ketika halaman ditutup.
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Menjalankan timer setelah Splash Screen pertama kali dibuka.
    _navigationTimer = Timer(
      const Duration(seconds: 3),
      () {
        // Memastikan widget masih aktif sebelum melakukan navigasi.
        if (!mounted) return;

        // Mengganti Splash Screen dengan halaman Login.
        // pushReplacementNamed mencegah pengguna kembali ke Splash
        // menggunakan tombol Back.
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.login,
        );
      },
    );
  }

  @override
  void dispose() {
    // Membatalkan timer jika Splash Screen ditutup lebih awal.
    // Hal ini mencegah timer berjalan ketika widget sudah tidak aktif.
    _navigationTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna utama Splash Screen mengikuti tema TaskZilla.
      backgroundColor: Colors.teal,

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Maskot sementara menggunakan ikon hewan.
              // Ikon ini dapat diganti dengan gambar Dino jika aset tersedia.
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(height: 24),

              // Nama aplikasi.
              const Text(
                'TaskZilla',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              // Slogan aplikasi pengelola tugas mahasiswa.
              const Text(
                'Smart Task Manager for Students',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 48),

              // Indikator bahwa aplikasi sedang mempersiapkan halaman.
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
