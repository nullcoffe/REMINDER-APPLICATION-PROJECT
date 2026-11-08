import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/priority_calculator.dart';
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
  final TextEditingController _subTaskController = TextEditingController();
  final TaskService _taskService = TaskService();
  final ChecklistService _checklistService = ChecklistService();

  DateTime? _selectedDate;
  bool _isSaving = false;
  late String _selectedCategory = AppStrings.categories.first;
  late String _selectedDifficulty = AppStrings.difficulties[1];

  // Daftar sub-tugas disimpan sementara sebelum tugas dibuat.
  final List<String> _subTasks = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subTaskController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // Memilih tanggal deadline.
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
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
      setState(() {
        _subTasks.add(title);
        _subTaskController.clear();
      });
    }
  }

  // Menghapus sub-tugas dari daftar sementara.
  void _removeSubTask(int index) {
    setState(() => _subTasks.removeAt(index));
  }

  // Menyimpan tugas beserta sub-tugas ke Firestore.
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

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSaving = true);

    try {
      final now = Timestamp.now();
      final taskId = FirebaseFirestore.instance.collection('tasks').doc().id;

      final task = TaskModel(
        id: taskId,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppStrings.addTaskTitle,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
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
              // Input judul tugas.
              TextFormField(
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

              // Input deskripsi tugas.
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
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Dropdown kategori.
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
                items: AppStrings.categories.map((String cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Dropdown tingkat kesulitan.
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Tingkat Kesulitan',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.speed_outlined,
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
                items: AppStrings.difficulties.map((String level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDifficulty = val);
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // Pemilih tanggal deadline.
              InkWell(
                onTap: _pickDate,
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
                              : 'Deadline: ${_formatDate(_selectedDate!)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: _selectedDate == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
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
            ],
          ),
        ),
      ),
    );
  }
}
