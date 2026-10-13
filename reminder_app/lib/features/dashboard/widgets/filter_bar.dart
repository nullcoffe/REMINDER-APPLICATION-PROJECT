
import 'package:flutter/material.dart';

// Widget untuk menampilkan pilihan filter daftar tugas.
// Widget ini hanya mengatur tampilan dan mengirimkan
// pilihan filter ke halaman yang memanggilnya.
class FilterBar extends StatelessWidget {
  // Daftar pilihan filter yang akan ditampilkan.
  // Nilai default disesuaikan dengan status tugas TaskZilla.
  final List<String> filters;

  // Filter yang sedang dipilih oleh pengguna.
  final String selectedFilter;

  // Fungsi yang dipanggil ketika pengguna memilih filter.
  final ValueChanged<String> onFilterChanged;

  const FilterBar({
    super.key,
    this.filters = const [
      'Semua',
      'To Do',
      'In Progress',
      'Done',
    ],
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat daftar pilihan filter yang dapat digeser
    // secara horizontal jika tidak cukup ruang.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          // Memeriksa apakah filter ini sedang dipilih.
          final bool isSelected = filter == selectedFilter;

          return Padding(
            // Memberikan jarak antarpilihan filter.
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              // Teks yang ditampilkan pada pilihan filter.
              label: Text(filter),

              // Menandai filter yang sedang aktif.
              selected: isSelected,

              // Mengatur warna pilihan aktif dan tidak aktif.
              selectedColor: Colors.teal,
              backgroundColor: Colors.grey.shade100,

              // Mengatur warna teks berdasarkan status pilihan.
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),

              // Menghilangkan ikon centang bawaan.
              showCheckmark: false,

              // Mengatur bentuk sudut pilihan filter.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Colors.teal
                      : Colors.grey.shade300,
                ),
              ),

              // Mengirimkan filter baru ke halaman pemanggil.
              onSelected: (_) {
                onFilterChanged(filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
