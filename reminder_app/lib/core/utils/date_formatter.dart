
import 'package:flutter/material.dart';

/// Helper untuk mengatur format tanggal dan waktu TaskZilla.
///
/// Penanggung jawab: Alya
/// File ini hanya mengatur tampilan tanggal,
/// bukan menghitung skor prioritas tugas.
class DateFormatter {
  DateFormatter._();

  /// Mengubah tanggal menjadi format dd/MM/yyyy.
  /// Contoh: 15/10/2026
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  /// Mengubah tanggal menjadi format tanggal dan bulan.
  /// Contoh: 15 Oktober
  static String formatDayMonth(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }

  /// Mengubah tanggal menjadi format lengkap.
  /// Contoh: 15 Oktober 2026
  static String formatFullDate(DateTime date) {
    return '${formatDayMonth(date)} ${date.year}';
  }

  /// Mengubah waktu menjadi format HH:mm.
  /// Contoh: 09:05
  static String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  /// Menggabungkan tanggal dan waktu.
  /// Contoh: 15/10/2026 09:05
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }

  /// Menghasilkan teks sisa waktu menuju deadline.
  /// Perhitungan hari mengikuti PriorityCalculator:
  /// waktu dibandingkan berdasarkan tanggal kalender.
  static String formatDeadline(DateTime deadline) {
    final daysRemaining =
        _daysUntilDeadline(deadline);

    if (daysRemaining < 0) {
      return 'Terlambat ${daysRemaining.abs()} hari';
    } else if (daysRemaining == 0) {
      return 'Deadline hari ini';
    } else if (daysRemaining == 1) {
      return 'Deadline besok';
    } else {
      return '$daysRemaining hari lagi';
    }
  }

  /// Menghitung selisih tanggal tanpa memperhitungkan jam.
  /// Logikanya disamakan dengan PriorityCalculator.
  static int _daysUntilDeadline(DateTime deadline) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final dueDate = DateTime(
      deadline.year,
      deadline.month,
      deadline.day,
    );

    return dueDate.difference(today).inDays;
  }
}
