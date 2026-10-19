import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/priority_calculator.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TaskService _taskService = TaskService();

  DateTime? _selectedDate;
  bool _isSaving = false;

  // Nilai awal diambil dari konstanta AppStrings.
  late String _selectedCategory = AppStrings.categories.first;
  late String _selectedDifficulty = AppStrings.difficulties[1]; // 'Sedang'

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // Memilih tanggal deadline
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
            ),
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

  // Menyimpan tugas ke Firestore lewat TaskService
  Future<void> _saveTask() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final selectedDate = _selectedDate;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih deadline tugas terlebih dahulu!'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu.')),
      );
      return;
    }

    // Diambil sebelum await agar tidak memakai context setelah jeda.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSaving = true);

    try {
      final now = Timestamp.now();

      final task = TaskModel(
        id: FirebaseFirestore.instance.collection('tasks').doc().id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory,
        userId: user.uid,
        deadline: Timestamp.fromDate(selectedDate),
        difficultyLevel: _selectedDifficulty,
        priorityScore: PriorityCalculator.calculateScore(selectedDate),
        status: AppStrings.statusTodo,
        createdAt: now,
        updatedAt: now,
      );

      await _taskService.createTask(task);

      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Tugas berhasil ditambahkan!')),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal menyimpan tugas: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addTaskTitle),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
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
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primaryTeal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: const BorderSide(
                      color: AppColors.borderLight,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: const BorderSide(
                      color: AppColors.primaryTeal,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Dropdown Kategori (dari AppStrings.categories)
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primaryTeal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                  ),
                ),
                items: AppStrings.categories.map((String cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Dropdown Tingkat Kesulitan (dari AppStrings.difficulties)
              DropdownButtonFormField<String>(
                initialValue: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Tingkat Kesulitan',
                  prefixIcon: const Icon(
                    Icons.speed_outlined,
                    color: AppColors.primaryTeal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                  ),
                ),
                items: AppStrings.difficulties.map((String level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDifficulty = val);
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
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryTeal,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        _selectedDate == null
                            ? 'Pilih Deadline Tugas'
                            : 'Deadline: ${_formatDate(_selectedDate!)}',
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedDate == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontWeight: _selectedDate == null
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Keterangan prioritas otomatis (muncul setelah deadline dipilih)
              if (_selectedDate != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(
                      'Prioritas otomatis: '
                      '${PriorityCalculator.getPriorityLabel(_selectedDate!)}',
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSizes.spaceL),

              // Tombol Simpan Tugas (diganti indikator saat proses berjalan)
              if (_isSaving)
                const Center(child: CircularProgressIndicator())
              else
                CustomButton(text: 'Simpan Tugas', onPressed: _saveTask),
            ],
          ),
        ),
      ),
    );
  }
}
