import 'package:flutter/material.dart';
import 'dart:async';
// [CATATAN RELASI ROUTE]: Pastikan rute atau halaman tujuan aman diimpor atau menggunakan nama string rute
// import '../../app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer selama 3 detik untuk berpindah halaman secara otomatis
    Timer(const Duration(seconds: 3), () {
      // [STRATEGI AMAN BENTROK]: Menggunakan navigasi langsung atau via named route
      // Jika AppRoutes belum sepenuhnya digabung oleh tim, ganti sementara dengan Navigator.pushReplacement
      // Navigator.pushReplacementNamed(context, '/login');
      
      // Navigasi aman sementara:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Halaman Utama / Login (Menunggu Merge Tim)'),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Menyesuaikan tema utama aplikasi
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustrasi / Maskot Dino (bisa diganti dengan Icon atau Image asset nantinya)
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
                Icons.pets, // Representasi sementara Mascot Dino
                size: 80,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 24),
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
            const Text(
              'Smart Task Manager for Students',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
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