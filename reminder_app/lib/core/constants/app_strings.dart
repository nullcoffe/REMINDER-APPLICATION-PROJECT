
/// Kumpulan teks statis yang digunakan dalam aplikasi TaskZilla.
///
/// Penanggung jawab: Alya
/// Status: Draft sementara.
/// Sumber teks: Laporan pengajuan ide aplikasi dan kode develop.
///
/// Catatan:
/// File ini hanya menyimpan teks, bukan ukuran tampilan.
/// Ukuran tampilan dikelola melalui core/constants/app_sizes.dart.
class AppStrings {
  AppStrings._();

  // Identitas aplikasi
  static const String appName = 'TaskZilla';
  static const String slogan = 'Deadline Aman, Kuliah Tenang.';
  static const String splashLabel = 'STUDENT PRODUCTIVITY';
  static const String splashTagline =
      'Kelola Tugas Kuliahmu, Taklukkan Deadlinemu';

  // Autentikasi (Login dan Register)
  static const String loginButton = 'Masuk';
  static const String registerButton = 'Daftar Sekarang';
  static const String registerTitle = 'Buat Akun Baru';
  static const String registerSubtitle =
      'Mulai atur jadwal dan deadline tanpa panik bareng TaskZilla!';
  static const String emailLabel = 'Email Mahasiswa';
  static const String passwordLabel = 'Kata Sandi';
  static const String passwordHint = 'Min. 8 karakter kombinasi';
  static const String fullNameHint = 'Sesuai KTM';

  // Pesan validasi
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

  // Status pengerjaan tugas
  static const String statusTodo = 'To Do';
  static const String statusInProgress = 'In Progress';
  static const String statusDone = 'Done';

  // Tingkat kesulitan tugas
  static const List<String> difficulties = [
    'Mudah',
    'Sedang',
    'Sulit',
  ];

  // Tingkat prioritas tugas
  static const String priorityUrgent = 'URGENT';
  static const String priorityHigh = 'HIGH';
  static const String priorityMedium = 'MEDIUM';
  static const String priorityLow = 'LOW';

  // Pesan saat belum ada notifikasi
  // Digunakan pada notification_screen.dart
  static const String notificationEmptyTitle =
      'Belum ada notifikasi';
  static const String notificationEmptyBody =
      'Pengingat tugas dan deadline kamu akan muncul di sini.';

  // Judul dan tombol pada layar tugas
  static const String addTaskTitle = 'Tambah Tugas Baru';
  static const String editTaskTitle = 'Edit Tugas';
  static const String saveChanges = 'Simpan Perubahan';
  static const String taskDetailTitle = 'Detail Tugas';
}
