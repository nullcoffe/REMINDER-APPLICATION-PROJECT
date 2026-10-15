import 'package:flutter/material.dart';
import '../../core/widgets/task_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState(); 
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variabel kategori filter aktif
  String selectedCategory = 'Semua';
  final List<String> categories = ['Semua', 'Kuliah', 'Tugas', 'Pribadi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskZilla Dashboard'),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Hubungkan ke notification_screen.dart milik Bintoro
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Sambutan Pengguna
            const Text(
              'Halo, Aliyah! 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Berikut daftar tugas kuliah dan aktivitasmu hari ini.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Bar Filter Kategori Sederhana
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: Colors.teal.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.teal.shade900 : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Daftar Tugas (Menggunakan TaskCard reusable core widget buatan Aliyah)
            const Text(
              'Daftar Tugas Aktif',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: ListView(
                children: [
                  TaskCard(
                    title: 'Implementasi Routing Flutter',
                    category: 'Kuliah',
                    priority: 'High',
                    deadline: 'Besok, 23:59 WIT',
                    onTap: () {
                      // TODO: Navigasi ke halaman detail tugas
                    },
                  ),
                  TaskCard(
                    title: 'Analisis Jaringan Komputer',
                    category: 'Kuliah',
                    priority: 'Urgent',
                    deadline: '14 Okt 2026',
                    onTap: () {},
                  ),
                  TaskCard(
                    title: 'Membuat Laporan Praktikum',
                    category: 'Pribadi',
                    priority: 'Medium',
                    deadline: '15 Okt 2026',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigasi ke add_task_screen.dart
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}