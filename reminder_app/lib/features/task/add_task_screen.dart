import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  DateTime? _selectedDate;
  // Mengambil kategori default pertama dari AppStrings.categories
  late String _selectedCategory = AppStrings.categories.first;
  String _selectedPriority = AppStrings.priorityMedium;

  // Daftar prioritas menggunakan konstanta dari AppStrings
  final List<String> _priorities = [
    AppStrings.priorityLow,
    AppStrings.priorityMedium,
    AppStrings.priorityHigh,
    AppStrings.priorityUrgent,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih tanggal deadline
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primaryTeal),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih deadline tugas terlebih dahulu!')),
        );
        return;
      }

      // TODO: Nantinya tinggal dihubungkan ke TaskProvider / FirestoreService buatan Laudya/Bintoro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil ditambahkan!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addTaskTitle),
        backgroundColor: AppColors.primaryTeal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Judul Tugas
              CustomTextField(
                controller: _titleController,
                labelText: 'Judul Tugas',
                hintText: 'Contoh: Laporan Praktikum Pemrograman Mobile',
                prefixIcon: Icons.assignment_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Field Deskripsi Tugas
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas (Opsional)',
                  hintText: 'Catatan tambahan mengenai tugas ini...',
                  prefixIcon: const Icon(Icons.description_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Dropdown Kategori (Mengambil dari AppStrings.categories)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.category_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusDefault)),
                ),
                items: AppStrings.categories.map((String cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Dropdown Prioritas
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Prioritas',
                  prefixIcon: const Icon(Icons.flag_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusDefault)),
                ),
                items: _priorities.map((String prio) {
                  return DropdownMenuItem(value: prio, child: Text(prio));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPriority = val);
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Pemilih Tanggal Deadline
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                child: Container(
                  padding: AppSizes.inputPadding,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    color: AppColors.surfaceLight,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppColors.primaryTeal),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        _selectedDate == null
                            ? 'Pilih Deadline Tugas'
                            : 'Deadline: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                          fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),

              // Tombol Simpan Tugas
              CustomButton(
                text: 'Simpan Tugas',
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}