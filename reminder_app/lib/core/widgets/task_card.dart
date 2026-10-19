
import 'package:flutter/material.dart';
import 'priority_badge.dart';

// Widget kartu untuk menampilkan ringkasan sebuah tugas.
// Data tugas diterima melalui parameter dari halaman pemanggil.
class TaskCard extends StatelessWidget {
  // Nama atau judul tugas.
  final String title;

  // Kategori tugas, misalnya individu atau kelompok.
  final String category;

  // Tingkat prioritas yang ditampilkan pada badge.
  final String priority;

  // Tanggal atau waktu batas pengumpulan tugas.
  final String deadline;

  // Fungsi yang dijalankan ketika kartu ditekan.
  final VoidCallback onTap;

  // Fungsi penghapusan yang bersifat opsional.
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.priority,
    required this.deadline,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat kartu dengan sudut membulat dan bayangan.
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      // Memotong tampilan anak widget sesuai bentuk kartu.
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        // Membuka detail tugas atau menjalankan aksi terkait.
        onTap: onTap,
        child: Padding(
          // Memberikan jarak antara isi dan tepi kartu.
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris judul, prioritas, dan tombol hapus.
              Row(
                children: [
                  // Judul menggunakan ruang yang tersedia.
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),

                      // Membatasi judul hingga dua baris.
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Menampilkan tingkat prioritas tugas.
                  PriorityBadge(
                    priority: priority,
                  ),

                  // Tombol hapus hanya muncul jika callback tersedia.
                  if (onDelete != null) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      // Menjalankan fungsi hapus dari halaman pemanggil.
                      onPressed: onDelete,
                      tooltip: 'Hapus tugas',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 10),

              // Baris informasi kategori tugas.
              Row(
                children: [
                  const Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),

                  // Mencegah teks kategori meluap.
                  Expanded(
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Baris informasi deadline tugas.
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),

                  // Menampilkan deadline dalam bentuk teks.
                  Expanded(
                    child: Text(
                      deadline,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
