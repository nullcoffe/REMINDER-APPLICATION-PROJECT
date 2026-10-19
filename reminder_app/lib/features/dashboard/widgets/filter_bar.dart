import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

// Widget untuk menampilkan pilihan filter daftar tugas.
// Widget ini hanya mengatur tampilan dan mengirimkan
// pilihan filter ke halaman yang memanggilnya.
class FilterBar extends StatelessWidget {
  // Daftar pilihan filter yang akan ditampilkan.
  final List<String> filters;

  // Filter yang sedang dipilih oleh pengguna.
  final String selectedFilter;

  // Fungsi yang dipanggil ketika pengguna memilih filter.
  final ValueChanged<String> onFilterChanged;

  const FilterBar({
    super.key,
    this.filters = const ['Semua', 'To Do', 'In Progress'],
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          // Memeriksa apakah filter ini sedang dipilih.
          final bool isSelected = filter == selectedFilter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
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
