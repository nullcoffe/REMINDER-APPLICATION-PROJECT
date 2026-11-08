import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
import '../../core/constants/app_colors.dart';
>>>>>>> develop
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
<<<<<<< HEAD
  // Inisialisasi layanan dan kunci form.
=======
>>>>>>> develop
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();
  final ChecklistService _checklistService = ChecklistService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _newSubTaskController;
<<<<<<< HEAD
=======

  late String _selectedCategory;
  late String _selectedPriority;
  late DateTime _deadline;

  bool _isLoading = false;
  bool _isSaving = false;

  final List<String> _priorities = [
    AppStrings.priorityLow,
    AppStrings.priorityMedium,
    AppStrings.priorityHigh,
    AppStrings.priorityUrgent,
  ];
>>>>>>> develop

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

<<<<<<< HEAD
  // Konversi antara skor numerik dan label string prioritas.
=======
>>>>>>> develop
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

<<<<<<< HEAD
  // Memformat DateTime menjadi string yang mudah dibaca.
=======
>>>>>>> develop
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

<<<<<<< HEAD
  // Menampilkan pemilih tanggal dan waktu untuk deadline.
=======
>>>>>>> develop
  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
<<<<<<< HEAD
=======
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
>>>>>>> develop
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

<<<<<<< HEAD
  // Menambahkan sub-tugas baru ke Firestore.
=======
>>>>>>> develop
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

<<<<<<< HEAD
  // Menghapus sub-tugas dari Firestore.
=======
>>>>>>> develop
  Future<void> _deleteSubTask(String subTaskId) async {
    try {
      await _checklistService.deleteChecklist(subTaskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sub-tugas dihapus'),
<<<<<<< HEAD
            backgroundColor: Colors.red,
=======
            backgroundColor: AppColors.error,
>>>>>>> develop
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: $e'),
<<<<<<< HEAD
            backgroundColor: Colors.red,
=======
            backgroundColor: AppColors.error,
>>>>>>> develop
          ),
        );
      }
    }
  }

<<<<<<< HEAD
  // Memvalidasi form dan menyimpan perubahan tugas.
=======
>>>>>>> develop
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
<<<<<<< HEAD
        content: const Text('Tugas berhasil diperbarui!'),
          backgroundColor: Colors.green,
=======
          content: Text(AppStrings.taskAddedSuccess),
          backgroundColor: AppColors.success,
>>>>>>> develop
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
<<<<<<< HEAD
          backgroundColor: Colors.red,
=======
          backgroundColor: AppColors.error,
>>>>>>> develop
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
<<<<<<< HEAD
              // Input teks untuk judul tugas.
              Text(
                'Judul Tugas *',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
=======
              // 1. Judul Tugas
              const Text(
                'Judul Tugas *',
                style: TextStyle(
                  color: AppColors.textSecondary,
>>>>>>> develop
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
<<<<<<< HEAD
                style: TextStyle(color: colorScheme.onSurface),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                decoration: InputDecoration(
                  hintText: 'Contoh: Laporan Praktikum',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surface,
=======
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                decoration: InputDecoration(
                  hintText: 'Contoh: Laporan Praktikum',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
>>>>>>> develop
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

<<<<<<< HEAD
              // Input teks untuk deskripsi tugas.
              Text(
                'Deskripsi Tugas (Opsional)',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
=======
              // 2. Deskripsi
              const Text(
                'Deskripsi Tugas (Opsional)',
                style: TextStyle(
                  color: AppColors.textSecondary,
>>>>>>> develop
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
<<<<<<< HEAD
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Detail tugas...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surface,
=======
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Detail tugas...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
>>>>>>> develop
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),

<<<<<<< HEAD
              // Dropdown untuk memilih kategori tugas.
              Text(
                'Kategori',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
=======
              // 3. Kategori (Sudah disederhanakan dari Mata Kuliah)
              const Text(
                'Kategori',
                style: TextStyle(
                  color: AppColors.textSecondary,
>>>>>>> develop
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color: colorScheme.surface,
=======
                  color: AppColors.surface,
>>>>>>> develop
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
<<<<<<< HEAD
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
=======
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textPrimary),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textSecondary,
                    ),
                    items: AppStrings.categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
>>>>>>> develop
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val!),
                  ),
                ),
              ),
              const SizedBox(height: 20),

<<<<<<< HEAD
              // Pemilih tenggat waktu dan pengingat.
              Text(
                'Tenggat Waktu & Pengingat',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
=======
              // 4. Tenggat Waktu
              const Text(
                'Tenggat Waktu & Pengingat',
                style: TextStyle(
                  color: AppColors.textSecondary,
>>>>>>> develop
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
<<<<<<< HEAD
                    color: colorScheme.surface,
=======
                    color: AppColors.surface,
>>>>>>> develop
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
<<<<<<< HEAD
                      Icon(
                        Icons.calendar_today,
                        color: colorScheme.primary,
=======
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
>>>>>>> develop
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatDeadline(_deadline),
<<<<<<< HEAD
                          style: TextStyle(
                            color: colorScheme.onSurface,
=======
                          style: const TextStyle(
                            color: AppColors.textPrimary,
>>>>>>> develop
                            fontSize: 14,
                          ),
                        ),
                      ),
<<<<<<< HEAD
                      Icon(
                        Icons.edit,
                        color: colorScheme.onSurfaceVariant,
=======
                      const Icon(
                        Icons.edit,
                        color: AppColors.textSecondary,
>>>>>>> develop
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

<<<<<<< HEAD
              // Dropdown untuk memilih tingkat prioritas.
              Text(
                'Prioritas Tugas',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
=======
              // 5. Prioritas
              const Text(
                'Prioritas Tugas',
                style: TextStyle(
                  color: AppColors.textSecondary,
>>>>>>> develop
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color: colorScheme.surface,
=======
                  color: AppColors.surface,
>>>>>>> develop
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPriority,
                    isExpanded: true,
<<<<<<< HEAD
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onSurface),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    items: _priorities
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
=======
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textPrimary),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textSecondary,
                    ),
                    items: _priorities.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
>>>>>>> develop
                    onChanged: (val) =>
                        setState(() => _selectedPriority = val!),
                  ),
                ),
              ),
              const SizedBox(height: 24),

<<<<<<< HEAD
              // Daftar sub-tugas (checklist) dan tombol tambah.
              Text(
                'Sub-tugas (Checklist)',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
=======
              // 6. Sub-tugas (Checklist)
              const Text(
                'Sub-tugas (Checklist)',
                style: TextStyle(
                  color: AppColors.textSecondary,
>>>>>>> develop
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color: colorScheme.surface,
=======
                  color: AppColors.surface,
>>>>>>> develop
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
<<<<<<< HEAD
                                color: colorScheme.onSurface,
=======
                                color: AppColors.textPrimary,
>>>>>>> develop
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
<<<<<<< HEAD
                                color: Colors.red,
=======
                                color: AppColors.error,
>>>>>>> develop
                                size: 20,
                              ),
                              onPressed: () => _deleteSubTask(item.id),
                            ),
                          ),
                        ),
<<<<<<< HEAD
=======

>>>>>>> develop
                        if (items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Belum ada sub-tugas',
<<<<<<< HEAD
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        Divider(color: colorScheme.outline, height: 1),
=======
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        Divider(color: AppColors.border, height: 1),

>>>>>>> develop
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
<<<<<<< HEAD
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
=======
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.primary,
                                ),
                                onPressed: () => _showAddSubTaskDialog(),
                              ),
                              const Text(
                                'Tambah sub-tugas',
                                style: TextStyle(
                                  color: AppColors.primary,
>>>>>>> develop
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

<<<<<<< HEAD
              // Tombol untuk menyimpan perubahan tugas.
=======
              // Tombol Simpan
>>>>>>> develop
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTask,
                  style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                    backgroundColor: colorScheme.primary,
=======
                    backgroundColor: AppColors.primary,
>>>>>>> develop
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
<<<<<<< HEAD
                      : Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
=======
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
>>>>>>> develop
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

<<<<<<< HEAD
  // Menampilkan dialog untuk menambahkan sub-tugas baru.
  Future<void> _showAddSubTaskDialog(ColorScheme colorScheme) async {
=======
  Future<void> _showAddSubTaskDialog() async {
>>>>>>> develop
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
<<<<<<< HEAD
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
=======
        backgroundColor: AppColors.surface,
        title: const Text(
          'Tambah Sub-tugas',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Judul sub-tugas...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.background,
>>>>>>> develop
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
<<<<<<< HEAD
            child: Text(
              'Batal',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
=======
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
>>>>>>> develop
            ),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _addSubTaskDirect(controller.text.trim());
                if (mounted) Navigator.pop(context);
              }
            },
<<<<<<< HEAD
            style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
=======
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
>>>>>>> develop
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
