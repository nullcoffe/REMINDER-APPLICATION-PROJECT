import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/app/routes/app_routes.dart';
import 'package:reminder_app/core/constants/app_colors.dart';
import 'package:reminder_app/core/constants/app_sizes.dart';
import 'package:reminder_app/core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Tunggu 3 detik, lalu cek status login untuk menentukan halaman tujuan
    _timer = Timer(const Duration(seconds: 3), _navigateNext);
  }

  void _navigateNext() {
    if (!mounted) return;

    // Auth gate: user sudah punya sesi aktif -> Dashboard, jika tidak -> Login
    final user = FirebaseAuth.instance.currentUser;
    final nextRoute = user != null ? AppRoutes.dashboard : AppRoutes.login;

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Maskot TaskZilla
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceS),
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
                  'assets/logo_taskzilla.jpeg', // Sesuaikan path sesuai letak foldermu
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceL),
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}