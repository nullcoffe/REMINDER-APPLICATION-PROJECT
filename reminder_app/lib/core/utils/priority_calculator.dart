class PriorityCalculator {
  PriorityCalculator._();

  /// Menghitung jumlah hari dari sekarang sampai deadline.
  static int daysUntilDeadline(DateTime deadline) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      deadline.year,
      deadline.month,
      deadline.day,
    );

    return dueDate.difference(today).inDays;
  }

  /// Menghitung skor prioritas tugas.
  ///
  /// Skor semakin tinggi jika deadline semakin dekat.
  /// Tugas yang sudah melewati deadline mendapatkan skor tertinggi.
  static int calculateScore(DateTime deadline) {
    final daysRemaining = daysUntilDeadline(deadline);

    if (daysRemaining < 0) {
      return 100;
    } else if (daysRemaining == 0) {
      return 90;
    } else if (daysRemaining <= 1) {
      return 80;
    } else if (daysRemaining <= 3) {
      return 60;
    } else if (daysRemaining <= 7) {
      return 40;
    } else {
      return 20;
    }
  }

  /// Mengubah skor menjadi label prioritas.
  static String getPriorityLabel(DateTime deadline) {
    final score = calculateScore(deadline);

    if (score >= 90) {
      return 'Sangat Tinggi';
    } else if (score >= 80) {
      return 'Tinggi';
    } else if (score >= 60) {
      return 'Sedang';
    } else {
      return 'Rendah';
    }
  }
}