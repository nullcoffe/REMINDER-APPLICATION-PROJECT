class AppStrings {
  AppStrings._();

  // Identitas
  static const String appName = 'TaskZilla';
  static const String slogan = 'Deadline Aman, Kuliah Tenang.';
  static const String splashLabel = 'STUDENT PRODUCTIVITY';
  static const String splashTagline = 'Kelola Tugas Kuliahmu, Taklukkan Deadlinemu';

  // Auth - Login
  static const String loginTitle = 'Masuk ke Akun';
  static const String loginSubtitle = 'Kelola jadwal kuliah dan tugas praktikummu kembali bersama TaskZilla.';
  static const String loginEmailHint = 'contoh@student.ac.id';
  static const String loginPasswordHint = 'Masukkan kata sandi';
  static const String loginForgotPassword = 'Lupa Kata Sandi?';
  static const String loginRememberMe = 'Ingat saya';
  static const String loginButton = 'Masuk';
  static const String loginNoAccount = 'Belum punya akun?';
  static const String loginRegisterNow = 'Daftar Sekarang';

  // Auth - Register
  static const String registerTitle = 'Buat Akun Baru';
  static const String registerSubtitle = 'Mulai atur tugasmu agar lebih terorganisir dan bebas panik bersama TaskZilla.';
  static const String registerFullNameLabel = 'Nama Lengkap';
  static const String registerFullNameHint = 'Masukkan nama lengkap';
  static const String registerEmailLabel = 'Email Mahasiswa / NIM';
  static const String registerEmailHelper = 'Email kampus/NIM';
  static const String registerEmailHint = 'contoh@student.ac.id';
  static const String registerPasswordLabel = 'Kata Sandi';
  static const String registerPasswordHint = 'Input kata sandi baru';
  static const String registerPasswordRule1 = 'Minimal 8 karakter';
  static const String registerPasswordRule2 = 'Kombinasi huruf & angka';
  static const String registerConfirmPasswordLabel = 'Konfirmasi Kata Sandi';
  static const String registerConfirmPasswordHint = 'Konfirmasi kata sandi';
  static const String registerButton = 'Daftar Akun';
  static const String registerHasAccount = 'Sudah punya akun?';
  static const String registerLoginNow = 'Masuk';

  // Validasi
  static const String fieldRequired = 'Field wajib diisi';
  static const String emailUsed = 'Email sudah digunakan. Gunakan email lain atau masuk.';
  static const String passwordMismatch = 'Kata sandi tidak cocok';
  static const String invalidPassword = 'Kata sandi tidak valid';

  // Kategori & Status
  static const List<String> categories = ['Individu', 'Kelompok', 'Proyek', 'Presentasi', 'Praktikum', 'UTS', 'UAS'];
  static const String statusTodo = 'To Do';
  static const String statusInProgress = 'In Progress';
  static const String statusDone = 'Done';

  // Tugas
  static const List<String> difficulties = ['Mudah', 'Sedang', 'Sulit'];
  static const String priorityUrgent = 'URGENT';
  static const String priorityHigh = 'HIGH';
  static const String priorityMedium = 'MEDIUM';
  static const String priorityLow = 'LOW';
  static const String addTaskTitle = 'Tambah Tugas Baru';
  static const String editTaskTitle = 'Edit Tugas';
  static const String saveChanges = 'Simpan Perubahan';
  static const String taskDetailTitle = 'Detail Tugas';

  // Notifikasi
  static const String notificationEmptyTitle = 'Belum ada notifikasi';
  static const String notificationEmptyBody = 'Pengingat tugas dan deadline kamu akan muncul di sini.';
}