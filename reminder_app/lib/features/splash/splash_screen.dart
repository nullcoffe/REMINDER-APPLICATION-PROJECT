import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

/// Splash Screen TaskZilla.
///
/// Tampil pertama kali saat aplikasi dibuka. Setelah 3 detik:
/// - pengguna yang sudah login diarahkan ke Dashboard,
/// - pengguna yang belum login diarahkan ke Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _logoPath = 'assets/logotaskzilla.jpeg';

  /// Menyimpan timer agar bisa dibatalkan ketika halaman ditutup.
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 3), _navigateNext);
  }

  void _navigateNext() {
    // Pastikan widget masih aktif sebelum melakukan navigasi.
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    final nextRoute = user != null ? AppRoutes.dashboard : AppRoutes.login;

    // pushReplacementNamed mencegah pengguna kembali ke Splash
    // menggunakan tombol Back.
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo TaskZilla di dalam lingkaran putih.
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    _logoPath,
                    fit: BoxFit.cover,
                    // Jika gambar gagal dimuat, tampilkan ikon pengganti
                    // agar aplikasi tidak crash.
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.pets,
                        size: 80,
                        color: AppColors.primaryTeal,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spaceL),

              // Nama aplikasi.
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: AppSizes.spaceS),

              // Label dan tagline aplikasi.
              const Text(
                AppStrings.splashLabel,
                style: TextStyle(
                  fontSize: AppSizes.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceL),
                child: Text(
                  AppStrings.splashTagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ),

              const SizedBox(height: 48),

              // Indikator bahwa aplikasi sedang mempersiapkan halaman.
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
