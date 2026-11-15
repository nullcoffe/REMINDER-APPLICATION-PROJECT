import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/priority_calculator.dart';
import '../../models/task_model.dart';
import '../../models/checklist_model.dart';
import '../../services/task_service.dart';
import '../../services/checklist_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  static const List<String> _steps = [
    AppStrings.statusTodo,
    AppStrings.statusInProgress,
    AppStrings.statusDone,
  ];

  static const List<IconData> _stepIcons = [
    Icons.assignment_outlined,
    Icons.autorenew,
    Icons.flag_outlined,
  ];

  final TaskService _taskService = TaskService();
  final ChecklistService _checklistService = ChecklistService();

  late TaskModel _task = widget.task;
  Timer? _ticker;
  bool _isUpdating = false;

  Stream<List<ChecklistModel>>? _checklistStream;
  List<ChecklistModel> _checklistItems = [];

  final TextEditingController _newSubTaskController = TextEditingController();
  bool _isAddingSubTask = false;

  // Getter untuk mengakses colorScheme dengan lebih ringkas.
  ColorScheme get _cs => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });

    _checklistStream = _checklistService.getChecklist(_task.id);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _newSubTaskController.dispose();
    super.dispose();
  }

  double _calculateProgressPercent(List<ChecklistModel> checklist) {
    if (checklist.isEmpty) return 0.0;
    final completedCount = checklist.where((item) => item.isCompleted).length;
    return completedCount / checklist.length;
  }

  String _calculateStatusFromChecklist(List<ChecklistModel> checklist) {
    if (checklist.isEmpty) return AppStrings.statusTodo;

    final completedCount = checklist.where((item) => item.isCompleted).length;
    final totalCount = checklist.length;

    if (completedCount == 0) return AppStrings.statusTodo;
    if (completedCount == totalCount) return AppStrings.statusDone;
    return AppStrings.statusInProgress;
  }

  int _getStepIndexFromChecklist(List<ChecklistModel> checklist) {
    final status = _calculateStatusFromChecklist(checklist);
    final normalizedStatus = _normalize(status);
    final index = _steps.indexWhere((s) => _normalize(s) == normalizedStatus);
    if (index != -1) return index;
    return 0;
  }

  Future<void> _addSubTask() async {
    final title = _newSubTaskController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul sub-tugas tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isAddingSubTask = true);

    try {
      final checklistRef = FirebaseFirestore.instance
          .collection('checklist')
          .doc();
      final newChecklist = ChecklistModel(
        id: checklistRef.id,
        taskId: _task.id,
        itemTitle: title,
        isCompleted: false,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await _checklistService.createChecklist(newChecklist);

      if (mounted) {
        _newSubTaskController.clear();
        setState(() => _isAddingSubTask = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sub-tugas berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAddingSubTask = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah sub-tugas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleChecklistItem(ChecklistModel item) async {
    try {
      final updatedItem = ChecklistModel(
        id: item.id,
        taskId: item.taskId,
        itemTitle: item.itemTitle,
        isCompleted: !item.isCompleted,
        createdAt: item.createdAt,
        updatedAt: Timestamp.now(),
      );

      await _checklistService.updateChecklist(updatedItem);

      final newChecklist = _checklistItems.map((c) {
        if (c.id == item.id) {
          return updatedItem;
        }
        return c;
      }).toList();

      if (mounted) {
        setState(() {
          _checklistItems = newChecklist;
        });

        final newStatus = _calculateStatusFromChecklist(newChecklist);
        if (_normalize(newStatus) != _normalize(_task.status)) {
          await _updateStatus(newStatus, showSnackBar: false);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui sub-tugas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteSubTask(ChecklistModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cs.surface,
        title: const Text('Hapus Sub-tugas'),
        content: Text('Yakin ingin menghapus "${item.itemTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: _cs.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _checklistService.deleteChecklist(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sub-tugas berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus sub-tugas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  DateTime get _deadline => _task.deadline.toDate();

  String _normalize(String value) {
    return value.replaceAll('_', ' ').trim().toLowerCase();
  }

  bool get _isDone =>
      _normalize(_task.status) == 'done' ||
      _normalize(_task.status) == 'completed';

  String _formatDeadline(DateTime date) {
    final month = AppStrings.monthsShort[date.month - 1];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} $month ${date.year}, $hour:$minute';
  }

  Color _priorityColor(int score) {
    if (score >= 80) return _cs.error;
    if (score >= 60) return _cs.primary;
    if (score >= 40) return _cs.secondary;
    return _cs.tertiary;
  }

  Future<void> _updateStatus(
    String newStatus, {
    bool showSnackBar = true,
  }) async {
    if (_isUpdating) return;
    if (_normalize(newStatus) == _normalize(_task.status)) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isUpdating = true);

    try {
      final updated = TaskModel(
        id: _task.id,
        title: _task.title,
        description: _task.description,
        categoryId: _task.categoryId,
        userId: _task.userId,
        deadline: _task.deadline,
        difficultyLevel: _task.difficultyLevel,
        priorityScore: _task.priorityScore,
        status: newStatus,
        createdAt: _task.createdAt,
        updatedAt: Timestamp.now(),
      );

      await _taskService.updateTask(updated);

      if (!mounted) return;
      setState(() => _task = updated);

      if (showSnackBar) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Status diperbarui')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _openEdit() {
    Navigator.pushNamed(context, AppRoutes.editTask, arguments: _task);
  }

  BoxDecoration get _cardDecoration {
    return BoxDecoration(
      color: _cs.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      border: Border.all(color: _cs.outline),
    );
  }

  Widget _chip({required String label, required Color color, IconData? icon}) {
    return Container(
      padding: AppSizes.badgePadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusBadge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.fontSizeXS, color: color),
            const SizedBox(width: AppSizes.spaceXS),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontSizeXS,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, {Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, size: AppSizes.fontSizeLarge, color: _cs.primary),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: _cs.onSurface,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _timeBox(int value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
        decoration: BoxDecoration(
          color: _cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        ),
        child: Column(
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: AppSizes.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: _cs.primary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSizes.fontSizeXS,
                fontWeight: FontWeight.w600,
                color: _cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepLine({required bool visible, required bool active}) {
    return Expanded(
      child: Container(
        height: AppSizes.spaceXS,
        color: visible
            ? (active ? _cs.primary : _cs.outline)
            : Colors.transparent,
      ),
    );
  }

  Widget _buildStepNode({
    required int index,
    required bool reached,
    required bool isCurrent,
    required bool showCheck,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              _stepLine(
                visible: index > 0,
                active: index <= _getStepIndexFromChecklist(_checklistItems),
              ),
              Container(
                width: AppSizes.spaceXL,
                height: AppSizes.spaceXL,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? _cs.primary : _cs.surfaceContainerHighest,
                  border: Border.all(
                    color: isCurrent ? _cs.tertiary : _cs.outline,
                    width: 2,
                  ),
                ),
                child: Icon(
                  showCheck ? Icons.check : _stepIcons[index],
                  size: AppSizes.fontSizeLarge,
                  color: reached ? _cs.onPrimary : _cs.onSurfaceVariant,
                ),
              ),
              _stepLine(
                visible: index < _steps.length - 1,
                active: index < _getStepIndexFromChecklist(_checklistItems),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.fontSizeXS,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: reached ? _cs.onSurface : _cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    final score = PriorityCalculator.calculateScore(_deadline);
    final priorityLabel = PriorityCalculator.getPriorityLabel(_deadline);

    return Wrap(
      spacing: AppSizes.spaceS,
      runSpacing: AppSizes.spaceS,
      children: [
        _chip(
          label: _task.categoryId,
          color: _cs.primary,
          icon: Icons.category_outlined,
        ),
        if (_task.difficultyLevel.isNotEmpty)
          _chip(
            label: 'Kesulitan: ${_task.difficultyLevel}',
            color: _cs.tertiary,
            icon: Icons.speed_outlined,
          ),
        _chip(
          label: 'Prioritas: $priorityLabel',
          color: _priorityColor(score),
          icon: Icons.priority_high,
        ),
      ],
    );
  }

  Widget _buildTitleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _task.title,
            style: TextStyle(
              fontSize: AppSizes.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: _cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: AppSizes.fontSizeLarge,
                color: _cs.primary,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deadline',
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeXS,
                        fontWeight: FontWeight.w600,
                        color: _cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatDeadline(_deadline),
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: _cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard() {
    final remaining = _deadline.difference(DateTime.now());
    final isOverdue = remaining.isNegative;
    final safe = isOverdue ? Duration.zero : remaining;

    final days = safe.inDays;
    final hours = safe.inHours.remainder(24);
    final minutes = safe.inMinutes.remainder(60);

    final String badgeLabel;
    final Color badgeColor;

    if (_isDone) {
      badgeLabel = 'Selesai';
      badgeColor = _cs.primary;
    } else if (isOverdue) {
      badgeLabel = 'Terlambat';
      badgeColor = _cs.error;
    } else {
      badgeLabel = 'Berjalan';
      badgeColor = Colors.green;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            Icons.timer_outlined,
            'Sisa Waktu Pengerjaan',
            trailing: _chip(label: badgeLabel, color: badgeColor),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Row(
            children: [
              _timeBox(days, 'Hari'),
              const SizedBox(width: AppSizes.spaceS),
              _timeBox(hours, 'Jam'),
              const SizedBox(width: AppSizes.spaceS),
              _timeBox(minutes, 'Menit'),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          Container(
            width: double.infinity,
            padding: AppSizes.inputPadding,
            decoration: BoxDecoration(
              color: _cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: AppSizes.fontSizeLarge,
                  color: _cs.tertiary,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    'Pengingat akan dikirim 1 hari sebelum deadline',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSmall,
                      color: _cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowCard() {
    return StreamBuilder<List<ChecklistModel>>(
      stream: _checklistStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            _checklistItems.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.spaceM),
            decoration: _cardDecoration,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.spaceM),
            decoration: _cardDecoration,
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final checklist = snapshot.data ?? [];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _checklistItems = checklist;
            });
          }
        });

        final progressPercent = _calculateProgressPercent(checklist);
        final completedCount = checklist
            .where((item) => item.isCompleted)
            .length;
        final totalCount = checklist.length;
        final currentStepIndex = _getStepIndexFromChecklist(checklist);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.spaceM),
          decoration: _cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                Icons.alt_route,
                'Tahapan Pengerjaan',
                trailing: _chip(
                  label: '${(progressPercent * 100).round()}% Selesai',
                  color: _cs.primary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.spaceXS),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  backgroundColor: _cs.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(_cs.primary),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_steps.length, (index) {
                  final reached = index <= currentStepIndex;
                  final isCurrent = index == currentStepIndex;
                  final showCheck =
                      index < currentStepIndex || (isCurrent && _isDone);
                  return _buildStepNode(
                    index: index,
                    reached: reached,
                    isCurrent: isCurrent,
                    showCheck: showCheck,
                    label: _steps[index],
                  );
                }),
              ),
              const SizedBox(height: AppSizes.spaceM),
              Divider(color: _cs.outline),
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Icon(
                    Icons.checklist,
                    size: AppSizes.fontSizeMedium,
                    color: _cs.primary,
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(
                    'Daftar Sub-tugas',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                      color: _cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$completedCount/$totalCount selesai',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                      color: _cs.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...checklist.map(
                (item) => CheckboxListTile(
                  value: item.isCompleted,
                  onChanged: (_) => _toggleChecklistItem(item),
                  activeColor: _cs.primary,
                  title: Text(
                    item.itemTitle,
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSmall,
                      color: _cs.onSurface,
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    item.isCompleted ? 'Selesai' : 'Belum',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeXS,
                      color: _cs.onSurfaceVariant,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: _cs.error,
                    ),
                    onPressed: () => _deleteSubTask(item),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceS),
                decoration: BoxDecoration(
                  color: _cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
                  border: Border.all(color: _cs.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newSubTaskController,
                        style: TextStyle(
                          color: _cs.onSurface,
                          fontSize: AppSizes.fontSizeSmall,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tulis sub-tugas baru...',
                          hintStyle: TextStyle(
                            color: _cs.onSurfaceVariant,
                            fontSize: AppSizes.fontSizeSmall,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _addSubTask(),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    IconButton(
                      icon: _isAddingSubTask
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.add_circle, color: _cs.primary),
                      onPressed: _isAddingSubTask ? null : _addSubTask,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDescriptionCard() {
    final description = _task.description.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.notes, 'Deskripsi Tugas'),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            description.isEmpty ? 'Tidak ada deskripsi' : description,
            style: TextStyle(
              fontSize: AppSizes.fontSizeMedium,
              height: 1.5,
              color: description.isEmpty ? _cs.onSurfaceVariant : _cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: _cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: _cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isDone ? 'Kerja Bagus!' : 'Tetap Semangat!',
            style: TextStyle(
              fontSize: AppSizes.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: _cs.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            _isDone
                ? 'Kamu sudah menyelesaikan tugas ini.'
                : 'Kamu pasti bisa menyelesaikan tugas ini!',
            style: TextStyle(
              fontSize: AppSizes.fontSizeSmall,
              color: _cs.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: _cs.surface,
        border: Border(top: BorderSide(color: _cs.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Tugas'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _cs.primary,
                  padding: AppSizes.buttonPadding,
                  side: BorderSide(color: _cs.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: (_isDone || _isUpdating)
                    ? null
                    : () => _updateStatus(AppStrings.statusDone),
                icon: _isUpdating
                    ? const SizedBox(
                        width: AppSizes.loadingIndicatorSize,
                        height: AppSizes.loadingIndicatorSize,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: const Text('Tandai Selesai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cs.primary,
                  foregroundColor: _cs.onPrimary,
                  disabledBackgroundColor: _cs.surfaceContainerHighest,
                  disabledForegroundColor: _cs.onSurfaceVariant,
                  padding: AppSizes.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cs.surface,
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
          style: TextStyle(color: _cs.onSurface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _cs.surface,
        foregroundColor: _cs.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: _cs.onSurface),
        actions: [
          IconButton(
            tooltip: 'Edit Tugas',
            onPressed: _openEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChips(),
            const SizedBox(height: AppSizes.spaceM),
            _buildTitleCard(),
            const SizedBox(height: AppSizes.spaceM),
            _buildCountdownCard(),
            const SizedBox(height: AppSizes.spaceM),
            _buildWorkflowCard(),
            const SizedBox(height: AppSizes.spaceM),
            _buildDescriptionCard(),
            const SizedBox(height: AppSizes.spaceM),
            _buildMotivationCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}