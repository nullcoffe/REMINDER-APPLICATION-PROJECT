
import 'package:flutter/material.dart';

// Widget untuk menampilkan label prioritas tugas
// dengan warna berbeda berdasarkan tingkat prioritas.
class PriorityBadge extends StatelessWidget {
  // Label prioritas yang diterima dari halaman pemanggil.
  final String priority;

  const PriorityBadge({
    super.key,
    required this.priority,
  });

  // Menentukan warna berdasarkan label prioritas.
  Color _getBadgeColor() {
    // Mengabaikan perbedaan huruf besar dan kecil
    // serta spasi di awal atau akhir teks.
    switch (priority.trim().toLowerCase()) {
      case 'sangat tinggi':
      case 'urgent':
        return Colors.red;

      case 'tinggi':
      case 'high':
        return Colors.orange;

      case 'sedang':
      case 'medium':
        return Colors.blue;

      case 'rendah':
      case 'low':
        return Colors.green;

      // Menggunakan abu-abu jika label tidak dikenali.
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna sesuai tingkat prioritas.
    final Color badgeColor = _getBadgeColor();

    // Membuat label prioritas dengan latar transparan.
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),

      // Mengatur warna latar, sudut, dan garis tepi.
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor,
        ),
      ),

      // Menampilkan nama prioritas pada badge.
      child: Text(
        priority,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
