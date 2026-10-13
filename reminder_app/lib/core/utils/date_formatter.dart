class DateFormatter {
  DateFormatter._();

  // Nama bulan dalam bahasa Indonesia.
  static const List<String> _monthNames = [
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

  /// Format tanggal numerik.
  /// Contoh: 05/10/2026
  static String formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/'
        '${_twoDigits(date.month)}/'
        '${date.year}';
  }

  /// Format tanggal dan bulan.
  /// Contoh: 5 Oktober
  static String formatDayMonth(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]}';
  }

  /// Format tanggal lengkap.
  /// Contoh: 5 Oktober 2026
  static String formatFullDate(DateTime date) {
    return '${formatDayMonth(date)} ${date.year}';
  }

  /// Format waktu 24 jam.
  /// Contoh: 09:05
  static String formatTime(DateTime date) {
    return '${_twoDigits(date.hour)}:'
        '${_twoDigits(date.minute)}';
  }

  /// Format tanggal beserta waktu.
  /// Contoh: 05/10/2026 09:05
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }

  /// Mengubah angka satu digit menjadi dua digit.
  static String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
