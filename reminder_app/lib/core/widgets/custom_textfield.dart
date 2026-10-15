
import 'package:flutter/material.dart';

// Widget kolom input yang dapat digunakan
// untuk memasukkan nama, email, kata sandi, dan data lainnya.
class CustomTextField extends StatelessWidget {
  // Mengelola teks yang dimasukkan oleh pengguna.
  final TextEditingController controller;

  // Label yang muncul pada kolom input.
  final String labelText;

  // Petunjuk teks sebelum pengguna mengetik.
  final String hintText;

  // Ikon yang ditampilkan di bagian kiri kolom.
  final IconData prefixIcon;

  // Menentukan apakah karakter input disembunyikan.
  final bool isPassword;

  // Menentukan jenis keyboard yang digunakan.
  final TextInputType keyboardType;

  // Fungsi untuk memeriksa apakah input sudah valid.
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat kolom input dengan dukungan validasi.
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,

      // Mengatur tampilan kolom input.
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,

        // Menampilkan ikon di sebelah kiri kolom.
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.teal,
        ),

        // Border ketika kolom tidak sedang dipilih.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        // Border saat kolom dalam keadaan normal.
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),

        // Border berubah warna ketika kolom dipilih.
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.teal,
            width: 2,
          ),
        ),

        // Border ketika input tidak valid.
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        // Border ketika kolom aktif dan input tidak valid.
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),

        // Memberikan warna latar pada kolom input.
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
