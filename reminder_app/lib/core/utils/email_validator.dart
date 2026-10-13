import '../constants/app_strings.dart';

/// Helper untuk validasi email pengguna TaskZilla.
///
/// Penanggung jawab: Alya
/// Digunakan pada form Login dan Register.
class EmailValidator {
  EmailValidator._();

  /// Memeriksa apakah email kosong.
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    return null;
  }

  /// Memeriksa format email sederhana.
  ///
  /// Mengembalikan null jika valid.
  /// Mengembalikan pesan jika email tidak valid.
  static String? validate(String? value) {
    final requiredError = validateRequired(value);

    if (requiredError != null) {
      return requiredError;
    }

    final email = value!.trim();

    final emailPattern =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Menghapus spasi di awal dan akhir email.
  static String normalize(String email) {
    return email.trim();
  }
}
