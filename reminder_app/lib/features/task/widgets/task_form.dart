import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

/// Form untuk memasukkan atau mengedit data tugas.
/// Form ini menangani input dan validasi dasar.
/// Proses penyimpanan data dilakukan oleh halaman pemanggil.
class TaskForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String selectedCategory;
  final DateTime? selectedDate;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onPickDate;

  const TaskForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedDate,
    required this.onCategoryChanged,
    required this.onPickDate,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  // Memeriksa apakah judul tugas sudah diisi.
  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    return null;
  }

  // Memformat tanggal agar mudah dibaca.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Input judul tugas.
        TextFormField(
          controller: widget.titleController,
          validator: _validateTitle,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Judul Tugas',
            hintText: 'Masukkan judul tugas',
            prefixIcon: const Icon(
              Icons.assignment_outlined,
              color: AppColors.primaryTeal,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spaceM),

        // Input deskripsi tugas.
        TextFormField(
          controller: widget.descriptionController,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Deskripsi Tugas (Opsional)',
            hintText: 'Masukkan deskripsi tugas',
            prefixIcon: const Icon(
              Icons.description_outlined,
              color: AppColors.primaryTeal,
            ),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spaceM),

        // Pilihan kategori tugas.
        DropdownButtonFormField<String>(
          initialValue: AppStrings.categories.contains(widget.selectedCategory)
              ? widget.selectedCategory
              : AppStrings.categories.first,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Kategori Tugas',
            prefixIcon: const Icon(
              Icons.category_outlined,
              color: AppColors.primaryTeal,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
          ),
          items: AppStrings.categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: widget.onCategoryChanged,
        ),

        const SizedBox(height: AppSizes.spaceM),

        // Tombol untuk memilih deadline.
        OutlinedButton.icon(
          onPressed: widget.onPickDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(
            widget.selectedDate == null
                ? 'Pilih Deadline Tugas'
                : 'Deadline: ${_formatDate(widget.selectedDate!)}',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryTeal,
            padding: AppSizes.inputPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
          ),
        ),
      ],
    );
  }
}
