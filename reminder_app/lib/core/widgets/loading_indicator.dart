
import 'package:flutter/material.dart';

// Widget untuk menampilkan indikator ketika
// aplikasi sedang memuat data atau menjalankan proses.
class LoadingIndicator extends StatelessWidget {
  // Pesan tambahan yang ditampilkan di bawah indikator.
  // Nilainya boleh kosong atau tidak diberikan.
  final String? message;

  const LoadingIndicator({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    // Menempatkan indikator di tengah area yang tersedia.
    return Center(
      child: Column(
        // Tinggi kolom menyesuaikan isi widget.
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lingkaran animasi selama proses berlangsung.
          const CircularProgressIndicator(
            color: Colors.teal,
          ),

          // Pesan hanya ditampilkan jika tidak kosong.
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 16),

            // Menampilkan informasi proses kepada pengguna.
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
