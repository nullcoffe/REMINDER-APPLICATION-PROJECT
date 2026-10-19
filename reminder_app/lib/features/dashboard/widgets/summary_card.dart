
import 'package:flutter/material.dart';

// Widget kartu untuk menampilkan ringkasan informasi tugas.
// Contohnya jumlah semua tugas, tugas berjalan,
// dan tugas yang sudah selesai.
class SummaryCard extends StatelessWidget {
  // Judul informasi yang ditampilkan pada kartu.
  final String title;

  // Nilai ringkasan, misalnya jumlah tugas.
  // Menggunakan String agar bisa menerima angka maupun teks.
  final String value;

  // Ikon yang mewakili informasi pada kartu.
  final IconData icon;

  // Warna utama kartu dan ikon.
  final Color color;

  // Keterangan tambahan yang bersifat opsional.
  final String? subtitle;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.teal,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat kartu ringkasan dengan sudut membulat.
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(
        // Memberikan jarak antara isi kartu dan tepinya.
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris ikon dan judul informasi.
            Row(
              children: [
                // Latar ikon menggunakan warna transparan.
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Ikon sesuai jenis ringkasan.
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 10),

                // Judul dapat menggunakan ruang yang tersedia.
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Menampilkan nilai utama ringkasan.
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            // Menampilkan keterangan tambahan jika tersedia.
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
