/// Teks statis TaskZilla.
///
/// DRAFT SEMENTARA (backup oleh Laili, PIC asli: Alya).
/// Teks diambil dari laporan pengajuan ide aplikasi (docx) dan kode develop.
class AppStrings {
  AppStrings._();

  // Identitas
  static const String appName = 'TaskZilla';
  static const String slogan = 'Deadline Aman, Kuliah Tenang.';
  static const String splashLabel = 'STUDENT PRODUCTIVITY';
  static const String splashTagline =
      'Kelola Tugas Kuliahmu, Taklukkan Deadlinemu';

  // Auth
  static const String loginButton = 'Masuk';
  static const String registerButton = 'Daftar Sekarang';
  static const String registerTitle = 'Buat Akun Baru';
  static const String registerSubtitle =
      'Mulai atur jadwal dan deadline tanpa panik bareng TaskZilla!';
  static const String emailLabel = 'Email Mahasiswa';
  static const String passwordLabel = 'Kata Sandi';
  static const String passwordHint = 'Min. 8 karakter kombinasi';
  static const String fullNameHint = 'Sesuai KTM';

  // Validasi
  static const String fieldRequired = 'Field wajib diisi';
  static const String emailUsed =
      'Email sudah digunakan. Gunakan email lain atau masuk.';

  // Kategori tugas
  static const List<String> categories = [
    'Individu',
    'Kelompok',
    'Proyek',
    'Presentasi',
    'Praktikum',
    'UTS',
    'UAS',
  ];

  // Status tugas
  static const String statusTodo = 'To Do';
  static const String statusInProgress = 'In Progress';
  static const String statusDone = 'Done';

  // Tingkat kesulitan
  static const List<String> difficulties = ['Mudah', 'Sedang', 'Sulit'];

  // Prioritas
  static const String priorityUrgent = 'URGENT';
  static const String priorityHigh = 'HIGH';
  static const String priorityMedium = 'MEDIUM';
  static const String priorityLow = 'LOW';

  // Empty state notifikasi (notification_screen.dart)
  static const String notificationEmptyTitle = 'Belum ada notifikasi';
  static const String notificationEmptyBody =
      'Pengingat tugas dan deadline kamu akan muncul di sini.';
}