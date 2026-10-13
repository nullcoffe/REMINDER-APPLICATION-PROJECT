// ============================================================
// FEATURE FLAGS TASKZILLA
// Penanggung jawab: ALYA
// File: lib/config/feature_flags.dart
//
// Fungsi:
// Mengatur fitur yang aktif atau belum aktif selama
// pengembangan aplikasi TaskZilla.
// ============================================================

class FeatureFlags {
  // Private constructor agar class tidak dibuat menjadi objek.
  FeatureFlags._();

  // ============================================================
  // FITUR TEMA APLIKASI - ALYA
  // ============================================================

  // Tema terang tersedia di AppTheme.
  static const bool enableLightTheme = true;

  // Tema gelap tersedia di AppTheme.
  static const bool enableDarkTheme = true;

  // Mengikuti tema perangkat jika tema gelap diaktifkan.
  static const bool followSystemTheme = true;

  // ============================================================
  // FITUR NAVIGASI - ALYA
  // ============================================================

  // Halaman awal aplikasi menggunakan rute Splash.
  static const bool enableSplashScreen = true;

  // ============================================================
  // FITUR APLIKASI TASKZILLA
  // ============================================================

  // Fitur autentikasi.
  static const bool enableLogin = true;
  static const bool enableRegister = true;

  // Fitur halaman utama.
  static const bool enableDashboard = true;

  // Fitur pengelolaan tugas.
  static const bool enableAddTask = true;
  static const bool enableEditTask = true;
  static const bool enableTaskDetail = true;

  // Fitur notifikasi.
  static const bool enableNotification = true;

  // Fitur riwayat dan profil.
  // Aktifkan setelah halaman aslinya selesai dibuat.
  static const bool enableHistory = false;
  static const bool enableProfile = false;
}