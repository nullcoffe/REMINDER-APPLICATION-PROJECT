import 'package:flutter/material.dart';
import '../../core/widgets/priority_badge.dart';

class TaskDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final String priority;
  final String deadline;

  const TaskDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.deadline,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Simulasi status checklist sub-tugas
  final List<Map<String, dynamic>> _subTasks = [
    {'title': 'Analisis kebutuhan sistem', 'isDone': true},
    {'title': 'Desain antarmuka (UI/UX)', 'isDone': false},
    {'title': 'Implementasi kode program', 'isDone': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: Navigasi ke EditTaskScreen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Judul dan Badge Prioritas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PriorityBadge(priority: widget.priority),
              ],
            ),
            const SizedBox(height: 16),

            // Informasi Kategori & Deadline
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.category_outlined, color: Colors.teal, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.category,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container(height: 24, width: 1, color: Colors.grey[300]),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined, color: Colors.teal, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.deadline,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bagian Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description.isEmpty
                  ? 'Tidak ada deskripsi tambahan untuk tugas ini.'
                  : widget.description,
              style: TextStyle(
                fontSize: 14,
                color: widget.description.isEmpty ? Colors.grey : Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Bagian Sub-Tugas / Checklist
            const Text(
              'Sub-Tugas (Checklist)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subTasks.length,
              itemBuilder: (context, index) {
                final subTask = _subTasks[index];
                return CheckboxListTile(
                  title: Text(
                    subTask['title'],
                    style: TextStyle(
                      decoration: subTask['isDone']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: subTask['isDone'] ? Colors.grey : Colors.black,
                    ),
                  ),
                  value: subTask['isDone'],
                  activeColor: Colors.teal,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (bool? value) {
                    setState(() {
                      _subTasks[index]['isDone'] = value ?? false;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}