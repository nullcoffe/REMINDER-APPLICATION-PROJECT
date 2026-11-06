import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/task_model.dart';
import '../../models/checklist_model.dart';
import '../../services/task_service.dart';
import '../../services/checklist_service.dart';

// Layar untuk mengedit detail tugas yang sudah ada.
class EditTaskScreen extends StatefulWidget {
  final TaskModel task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // Inisialisasi layanan dan kunci form.
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();
  final ChecklistService _checklistService = ChecklistService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _newSubTaskController;

  late String _selectedCategory;
  late String _selectedPriority;
  late DateTime _deadline;

  bool _isSaving = false;

  final List<String> _priorities = [
    AppStrings.priorityLow,
    AppStrings.priorityMedium,
    AppStrings.priorityHigh,
    AppStrings.priorityUrgent,
  ];

  // Mengisi controller dan state awal dari data tugas.
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );

    _selectedCategory = widget.task.categoryId.isNotEmpty
        ? widget.task.categoryId
        : AppStrings.categories.first;

    _deadline = widget.task.deadline.toDate();
    _selectedPriority = _getPriorityFromScore(widget.task.priorityScore);
    _newSubTaskController = TextEditingController();
  }

  // Membersihkan controller dari memori saat widget dihancurkan.
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _newSubTaskController.dispose();
    super.dispose();
  }

  // Konversi antara skor numerik dan label string prioritas.
  String _getPriorityFromScore(int score) {
    if (score >= 80) return AppStrings.priorityUrgent;
    if (score >= 60) return AppStrings.priorityHigh;
    if (score >= 40) return AppStrings.priorityMedium;
    return AppStrings.priorityLow;
  }

  int _getScoreFromPriority(String priority) {
    if (priority == AppStrings.priorityUrgent) return 80;
    if (priority == AppStrings.priorityHigh) return 60;
    if (priority == AppStrings.priorityMedium) return 40;
    return 20;
  }

  // Memformat DateTime menjadi string yang mudah dibaca.
  String _formatDeadline(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute WIB';
  }

  // Menampilkan pemilih tanggal dan waktu untuk deadline.
  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadline),
      );

      if (pickedTime != null) {
        setState(() {
          _deadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Menambahkan sub-tugas baru ke Firestore.
  Future<void> _addSubTaskDirect(String title) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('checklist').doc();
      final newSubTask = ChecklistModel(
        id: docRef.id,
        taskId: widget.task.id,
        itemTitle: title,
        isCompleted: false,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      await _checklistService.createChecklist(newSubTask);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // Menghapus sub-tugas dari Firestore.
  Future<void> _deleteSubTask(String subTaskId) async {
    try {
      await _checklistService.deleteChecklist(subTaskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sub-tugas dihapus'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Memvalidasi form dan menyimpan perubahan tugas.
  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final updatedTask = TaskModel(
        id: widget.task.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory,
        userId: widget.task.userId,
        deadline: Timestamp.fromDate(_deadline),
        difficultyLevel: widget.task.difficultyLevel,
        priorityScore: _getScoreFromPriority(_selectedPriority),
        status: widget.task.status,
        createdAt: widget.task.createdAt,
        updatedAt: Timestamp.now(),
      );

      await _taskService.updateTask(updatedTask);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: const Text('Tugas berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil skema warna dari tema aktif untuk menyesuaikan UI.
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppStrings.editTaskTitle,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
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
              // Input teks untuk judul tugas.
              Text(
                'Judul Tugas *',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: colorScheme.onSurface),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                decoration: InputDecoration(
                  hintText: 'Contoh: Laporan Praktikum',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input teks untuk deskripsi tugas.
              Text(
                'Deskripsi Tugas (Opsional)',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Detail tugas...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown untuk memilih kategori tugas.
              Text(
                'Kategori',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onSurface),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    items: AppStrings.categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val!),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Pemilih tenggat waktu dan pengingat.
              Text(
                'Tenggat Waktu & Pengingat',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDeadline,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatDeadline(_deadline),
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown untuk memilih tingkat prioritas.
              Text(
                'Prioritas Tugas',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPriority,
                    isExpanded: true,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onSurface),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    items: _priorities
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedPriority = val!),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Daftar sub-tugas (checklist) dan tombol tambah.
              Text(
                'Sub-tugas (Checklist)',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: StreamBuilder<List<ChecklistModel>>(
                  stream: _checklistService.getChecklist(widget.task.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];

                    return Column(
                      children: [
                        ...items.map(
                          (item) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              item.itemTitle,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () => _deleteSubTask(item.id),
                            ),
                          ),
                        ),
                        if (items.isEmpty)
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
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: colorScheme.primary,
                                ),
                                onPressed: () =>
                                    _showAddSubTaskDialog(colorScheme),
                              ),
                              Text(
                                'Tambah sub-tugas',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Tombol untuk menyimpan perubahan tugas.
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Menampilkan dialog untuk menambahkan sub-tugas baru.
  Future<void> _showAddSubTaskDialog(ColorScheme colorScheme) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Tambah Sub-tugas',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Judul sub-tugas...',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: colorScheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          autofocus: true,
          onSubmitted: (val) async {
            if (val.trim().isNotEmpty) {
              await _addSubTaskDirect(val.trim());
              if (mounted) Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _addSubTaskDirect(controller.text.trim());
                if (mounted) Navigator.pop(context);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
