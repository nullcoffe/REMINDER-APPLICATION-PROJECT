import 'package:flutter/material.dart';

/// Kartu ringkasan kecil (Aktif, Mendesak, Selesai, dll) di dashboard.
///

class SummaryCard extends StatelessWidget {
  /// Teks keterangan, mis. "Mendesak".
  final String label;

  /// Angka yang ditampilkan.
  final int count;

  /// Ikon di bagian atas kartu.
  final IconData icon;

  /// Warna aksen kartu.
  final Color color;

  /// Opsional: teks kecil tambahan di bawah label, mis. "minggu ini".
  final String? subtitle;

  /// Opsional: kalau diisi, kartu bisa diklik.
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    this.color = Colors.teal,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = Color.lerp(Colors.white, color, 0.10)!;
    final border = Color.lerp(Colors.white, color, 0.30)!;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  if (onTap != null)
                    Icon(Icons.chevron_right, color: color, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              // Angka beranimasi halus saat berubah (mis. ganti filter).
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Text(
                  '$count',
                  key: ValueKey<int>(count),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }
}