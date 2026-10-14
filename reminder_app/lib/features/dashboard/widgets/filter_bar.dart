import 'package:flutter/material.dart';

/// Bar filter kategori (scroll horizontal) untuk DashboardScreen.
///
/// Berdiri sendiri: tidak meng-import file lain di proyek, jadi aman dari
/// bentrok. Semua data & warna dikirim lewat parameter.
class FilterBar extends StatelessWidget {
  /// Daftar nama kategori (termasuk "Semua" kalau diinginkan).
  final List<String> categories;

  /// Kategori yang sedang aktif.
  final String selectedCategory;

  /// Dipanggil saat sebuah kategori dipilih.
  final ValueChanged<String> onSelected;

  /// Warna chip aktif. Nanti bisa diisi AppColors.primary.
  final Color activeColor;

  /// Opsional: jumlah tugas per kategori, mis. {'Kuliah': 3}.
  /// Kalau diisi, angka ditampilkan di samping nama kategori.
  final Map<String, int>? counts;

  const FilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    this.activeColor = Colors.teal,
    this.counts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final count = counts?[category];
          final label = count == null ? category : '$category ($count)';

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: Color.lerp(Colors.white, activeColor, 0.18),
            backgroundColor: Colors.grey.shade100,
            side: BorderSide(
              color: isSelected ? activeColor : Colors.grey.shade300,
            ),
            labelStyle: TextStyle(
              color: isSelected ? activeColor : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}