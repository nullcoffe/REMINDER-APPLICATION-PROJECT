import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/task_model.dart';
import '../../models/checklist_model.dart';
import '../../services/task_service.dart';
import '../../services/checklist_service.dart';

// Layar untuk menambahkan tugas baru.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();
<<<<<<< HEAD
  final TextEditingController _subTaskController = TextEditingController();
=======

>>>>>>> develop
  final TaskService _taskService = TaskService();
  final ChecklistService _checklistService = ChecklistService();

  DateTime? _selectedDate;

  late String _selectedCategory = AppStrings.categories.first;

  String _selectedPriority = AppStrings.priorityMedium;

  bool _isSaving = false;
<<<<<<< HEAD
  late String _selectedCategory = AppStrings.categories.first;
  late String _selectedDifficulty = AppStrings.difficulties[1];

  // Daftar sub-tugas disimpan sementara sebelum tugas dibuat.
  final List<String> _subTasks = [];
=======

  final List<String> _priorities = [
    AppStrings.priorityLow,
    AppStrings.priorityMedium,
    AppStrings.priorityHigh,
    AppStrings.priorityUrgent,
  ];
>>>>>>> develop

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subTaskController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

=======
>>>>>>> develop
  // Memilih tanggal deadline.
  Future<void> _pickDate() async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
<<<<<<< HEAD
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // Menambahkan sub-tugas ke daftar sementara.
  void _addSubTask() {
    final title = _subTaskController.text.trim();
    if (title.isNotEmpty) {
=======
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
>>>>>>> develop
      setState(() {
        _subTasks.add(title);
        _subTaskController.clear();
      });
    }
  }

<<<<<<< HEAD
  // Menghapus sub-tugas dari daftar sementara.
  void _removeSubTask(int index) {
    setState(() => _subTasks.removeAt(index));
  }

  // Menyimpan tugas beserta sub-tugas ke Firestore.
=======
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
>>>>>>> develop
  Future<void> _saveTask() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
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

<<<<<<< HEAD
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSaving = true);

    try {
      final now = Timestamp.now();
      final taskId = FirebaseFirestore.instance.collection('tasks').doc().id;

      final task = TaskModel(
        id: taskId,
=======
    setState(() {
      _isSaving = true;
    });

    try {
      // Membuat ID dokumen unik.
      final taskRef = FirebaseFirestore.instance.collection('tasks').doc();

      final task = TaskModel(
        id: taskRef.id,
>>>>>>> develop
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

      // Simpan sub-tugas sebagai checklist setelah tugas dibuat.
      for (final title in _subTasks) {
        final subTask = ChecklistModel(
          id: FirebaseFirestore.instance.collection('checklist').doc().id,
          taskId: taskId,
          itemTitle: title,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        );
        await _checklistService.createChecklist(subTask);
      }

      if (!mounted) return;

      // Diubah menggunakan AppStrings.taskAddedSuccess ("Tugas tersimpan")
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.taskAddedSuccess)),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(
          AppStrings.addTaskTitle,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
=======
        title: const Text(AppStrings.addTaskTitle),
        backgroundColor: AppColors.primaryTeal,
>>>>>>> develop
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // Input judul tugas.
              TextFormField(
=======
              // Judul task.
              CustomTextField(
>>>>>>> develop
                controller: _titleController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Judul Tugas',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  hintText: 'Contoh: Laporan Praktikum Pemrograman Mobile',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.assignment_outlined,
                    color: colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.fieldRequired;
                  }

                  return null;
                },
              ),

              const SizedBox(height: AppSizes.spaceM),

<<<<<<< HEAD
              // Input deskripsi tugas.
=======
              // Deskripsi task.
>>>>>>> develop
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas (Opsional)',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  hintText: 'Catatan tambahan mengenai tugas ini...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.description_outlined,
                    color: colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
<<<<<<< HEAD
                    borderSide: BorderSide(color: colorScheme.outline),
=======
                    borderSide: const BorderSide(color: AppColors.borderLight),
>>>>>>> develop
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
              ),

              const SizedBox(height: AppSizes.spaceM),

<<<<<<< HEAD
              // Dropdown kategori.
=======
              // Kategori.
>>>>>>> develop
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                dropdownColor: colorScheme.surface,
                style: TextStyle(color: colorScheme.onSurface),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant,
                ),
                items: AppStrings.categories.map((cat) {
                  return DropdownMenuItem<String>(value: cat, child: Text(cat));
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

<<<<<<< HEAD
              // Dropdown tingkat kesulitan.
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Tingkat Kesulitan',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.speed_outlined,
                    color: colorScheme.primary,
=======
              // Prioritas.
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Prioritas',
                  prefixIcon: const Icon(
                    Icons.flag_outlined,
                    color: AppColors.primaryTeal,
>>>>>>> develop
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                dropdownColor: colorScheme.surface,
                style: TextStyle(color: colorScheme.onSurface),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant,
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

<<<<<<< HEAD
              // Pemilih tanggal deadline.
=======
              // Deadline.
>>>>>>> develop
              InkWell(
                onTap: _isSaving ? null : _pickDate,
                borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                child: Container(
                  padding: AppSizes.inputPadding,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                    color: colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Pilih Deadline Tugas'
<<<<<<< HEAD
                              : 'Deadline: ${_formatDate(_selectedDate!)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: _selectedDate == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
=======
                              : 'Deadline: '
                                    '${_selectedDate!.day}/'
                                    '${_selectedDate!.month}/'
                                    '${_selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 15,
                            color: _selectedDate == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
>>>>>>> develop
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

<<<<<<< HEAD
              // Keterangan prioritas otomatis.
              if (_selectedDate != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: AppSizes.iconSmall,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(
                      'Prioritas otomatis: ${PriorityCalculator.getPriorityLabel(_selectedDate!)}',
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeSmall,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSizes.spaceM),

              // Daftar sub-tugas.
              Text(
                'Sub-tugas (Checklist)',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  children: [
                    ..._subTasks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final title = entry.value;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(
                          title,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.error,
                            size: 20,
                          ),
                          onPressed: () => _removeSubTask(index),
                        ),
                      );
                    }),
                    if (_subTasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Belum ada sub-tugas',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    Divider(color: colorScheme.outline, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _subTaskController,
                              style: TextStyle(color: colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: 'Judul sub-tugas...',
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              onSubmitted: (_) => _addSubTask(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: colorScheme.primary,
                            ),
                            onPressed: _addSubTask,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),

              // Tombol simpan.
              if (_isSaving)
                const Center(child: CircularProgressIndicator())
              else
                CustomButton(text: 'Simpan Tugas', onPressed: _saveTask),
=======
              const SizedBox(height: AppSizes.spaceL),

              // Tombol simpan.
              CustomButton(
                text: _isSaving ? 'Menyimpan...' : 'Simpan Tugas',
                onPressed: () {
                  if (_isSaving) return;
                  _saveTask();
                },
              ),
>>>>>>> develop
            ],
          ),
        ),
      ),
    );
  }
}
