
import 'package:flutter/material.dart';

// Widget tombol yang bisa digunakan berulang kali
// pada halaman Login, Register, maupun halaman lainnya.
class CustomButton extends StatelessWidget {
  // Teks yang ditampilkan pada tombol.
  final String text;

  // Fungsi yang dijalankan ketika tombol ditekan.
  final VoidCallback onPressed;

  // Menandakan apakah tombol sedang memproses sesuatu.
  final bool isLoading;

  // Warna tombol dapat diatur dari halaman pemanggil.
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat tombol memenuhi lebar layar
    // dengan tinggi tetap 50 piksel.
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // Tombol dinonaktifkan saat proses loading.
        onPressed: isLoading ? null : onPressed,

        // Mengatur warna, bentuk, dan bayangan tombol.
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.teal,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.teal.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),

        // Menampilkan indikator loading atau teks tombol.
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
