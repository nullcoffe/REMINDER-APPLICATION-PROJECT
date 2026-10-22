
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
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

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TaskService _taskService = TaskService();

  DateTime? _selectedDate;

  late String _selectedCategory =
      AppStrings.categories.first;

  String _selectedPriority = AppStrings.priorityMedium;

  bool _isSaving = false;

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

  // Memilih tanggal deadline.
  Future<void> _pickDate() async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2035),
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

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Mengubah label prioritas menjadi skor numerik.
  int _getPriorityScore() {
    if (_selectedPriority == AppStrings.priorityLow) {
      return 20;
    }

    if (_selectedPriority == AppStrings.priorityMedium) {
      return 40;
    }

    if (_selectedPriority == AppStrings.priorityHigh) {
      return 60;
    }

    if (_selectedPriority == AppStrings.priorityUrgent) {
      return 80;
    }

    throw Exception('Prioritas yang dipilih tidak valid.');
  }

  // Menyimpan task ke Firestore.
  Future<void> _saveTask() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan pilih deadline tugas terlebih dahulu!',
          ),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan login terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Membuat ID dokumen unik.
      final taskRef = FirebaseFirestore.instance
          .collection('tasks')
          .doc();

      final task = TaskModel(
        id: taskRef.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory,
        userId: user.uid,
        deadline: Timestamp.fromDate(_selectedDate!),
        difficultyLevel: 'medium',
        priorityScore: _getPriorityScore(),
        status: 'to-do',
      );

      await _taskService.createTask(task);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tugas berhasil disimpan ke Firestore.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan tugas: ${e.code} - ${e.message ?? ''}',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan tugas: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
        padding: const EdgeInsets.all(
          AppSizes.pagePadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul task.
              CustomTextField(
                controller: _titleController,
                labelText: 'Judul Tugas',
                hintText:
                    'Contoh: Laporan Praktikum Pemrograman Mobile',
                prefixIcon: Icons.assignment_outlined,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return AppStrings.fieldRequired;
                  }

                  return null;
                },
              ),

              const SizedBox(height: AppSizes.spaceM),

              // Deskripsi task.
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas (Opsional)',
                  hintText:
                      'Catatan tambahan mengenai tugas ini...',
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primaryTeal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusDefault,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusDefault,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.borderLight,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusDefault,
                    ),
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

              // Kategori.
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primaryTeal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusDefault,
                    ),
                  ),
                ),
                items: AppStrings.categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
              ),

              const SizedBox(height: AppSizes.spaceM),

              // Prioritas.
              DropdownButtonFormField<String>(
                initialValue: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Prioritas',
                  prefixIcon: const Icon(
                    Icons.flag_outlined,
                    color: AppColors.primaryTeal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusDefault,
                    ),
                  ),
                ),
                items: _priorities.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
              ),

              const SizedBox(height: AppSizes.spaceM),

              // Deadline.
              InkWell(
                onTap: _isSaving ? null : _pickDate,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusDefault,
                ),
                child: Container(
                  padding: AppSizes.inputPadding,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderLight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusDefault,
                    ),
                    color: AppColors.surfaceLight,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryTeal,
                      ),
                      const SizedBox(
                        width: AppSizes.spaceS,
                      ),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Pilih Deadline Tugas'
                              : 'Deadline: '
                                  '${_selectedDate!.day}/'
                                  '${_selectedDate!.month}/'
                                  '${_selectedDate!.year}',
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
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spaceL),

              // Tombol simpan.
              CustomButton(
                text: _isSaving
                    ? 'Menyimpan...'
                    : 'Simpan Tugas',
                onPressed: () {
                  if (_isSaving) return;
                  _saveTask();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}