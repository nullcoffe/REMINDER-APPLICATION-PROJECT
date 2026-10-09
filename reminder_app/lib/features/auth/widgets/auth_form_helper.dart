// =============================================================================
// auth_form_helper.dart  (PIC: Laili)

// Anggap file ini "kotak perkakas" buat layar login & register.
// Isinya: warna, aturan validasi, dan potongan-potongan UI (header, input,
// tombol, bar kekuatan password) yang dipakai di dua layar sekaligus.

// Kenapa dibikin sendiri, Karena file teman (app_colors, custom_button, dll) belum di-push. Jadi kita
// bikin versi lokal dulu biar bisa jalan. Nanti kalau punya mereka sudah masuk
// ke develop, tinggal diganti di file ini aja, layar login/register nggak
// perlu diubah.

//   AuthStyle            -> nanti diganti AppColors / AppSizes   (Alya)
//   AuthTextField        -> nanti diganti CustomTextField        (Aliyah)
//   AuthButton           -> nanti diganti CustomButton           (Aliyah)
//   AuthValidators.email -> nanti diarahkan ke EmailValidator    (Alya)
// =============================================================================

// Import wajib: semua widget Flutter (Text, Row, Container, dll) datang dari sini.
// Kalau baris ini hilang, hampir semua kode bakal error merah.
import 'package:flutter/material.dart';

/// Kumpulan warna & ukuran yang dipakai di layar auth.
/// Nilainya diambil dari desain Figma (tema Teal).

// Semua `static const`, jadi bisa dipanggil langsung tanpa bikin objek:
// contohnya `AuthStyle.primary`.
class AuthStyle {
  // Constructor private: class ini cuma wadah konstanta,
  // jadi nggak boleh dibuat objeknya (AuthStyle() -> error).
  AuthStyle._();

  // --- Warna ---
  static const Color primary = Color(0xFF14B8A6); // teal utama (tombol, link)
  static const Color background = Color(0xFFF5F7FF); // latar belakang layar
  static const Color fieldFill = Color(0xFFF1F4FB); // isi kotak input
  static const Color border = Color(0xFFE2E8F0); // garis tepi input
  static const Color textDark = Color(0xFF1E293B); // teks utama
  static const Color textGrey = Color(0xFF64748B); // teks pendukung
  static const Color hint = Color(0xFF94A3B8); // teks placeholder & ikon
  static const Color error = Color(0xFFEF4444); // merah untuk pesan error
  static const Color warning = Color(0xFFF59E0B); // oranye untuk "Cukup"

  // --- Ukuran ---
  static const double radius = 12; // sudut membulat input & tombol
  static const double pagePadding = 24; // jarak isi ke tepi layar
  static const double maxContentWidth = 420; // biar di layar lebar (web/tablet)
  // form nggak melebar kebangetan
}

// Kumpulan aturan validasi form.

// Aturan mainnya simpel: kalau input BENAR, return `null`.
// Kalau SALAH, return teks pesan errornya. Flutter otomatis
// nampilin teks itu di bawah kolom input (merah).
class AuthValidators {
  AuthValidators._();

  // Pola (regex) buat ngecek bentuk email: ada teks, "@", domain, titik, akhiran.
  // Contoh lolos: nama@gmail.com, budi.s@student.ac.id
  static final RegExp _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  // Validasi email.
  // Yang dicek: nggak kosong, dan formatnya bener.
  static String? email(String? value) {
    // `?.trim()` buang spasi di awal/akhir; `?? ''` jaga-jaga kalau value null.
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email tidak boleh kosong';
    if (!_emailRegex.hasMatch(text)) return 'Format email tidak valid';
    return null; // null = lolos
  }

  // Validasi password: nggak kosong dan minimal 8 karakter
  // (angka 8 yang jadi indikator minimal bisa diubah lewat parameter minLength).
  static String? password(String? value, {int minLength = 8}) {
    final text = value ?? ''; // password sengaja TIDAK di-trim (spasi bisa jadi bagian password)
    if (text.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (text.length < minLength) return 'Kata sandi minimal $minLength karakter';
    return null;
  }

  // Validasi konfirmasi password: harus sama persis dengan password asli.
  // `original` diisi dari kolom password di layar register.
  static String? confirmPassword(String? value, String original) {
    final text = value ?? '';
    if (text.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong';
    if (text != original) return 'Kata sandi tidak sama';
    return null;
  }

  // Hitung "kekuatan" password dengan skor 0 sampai 4.
  // Tiap kriteria yang terpenuhi nambah 1 poin:
  //   1. panjang >= 8
  //   2. ada huruf besar DAN huruf kecil
  //   3. ada angka
  //   4. ada simbol (misalnya ! @ # $)
  static int passwordStrength(String value) {
    if (value.isEmpty) return 0;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[a-z]').hasMatch(value) && RegExp(r'[A-Z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[^\w\s]').hasMatch(value)) score++;
    return score;
  }
}

// Bagian kepala layar: logo bulat, (opsional) tulisan "Task Zilla",
// judul, dan subjudul. Dipakai di login & register biar tampilannya seragam.

// StatelessWidget = widget yang nggak punya data berubah-ubah,
// cukup menampilkan apa yang dikasih lewat parameter.
class AuthHeader extends StatelessWidget {
  final String title; // judul besar, misal "Masuk ke Akun Anda"
  final String subtitle; // teks kecil di bawah judul
  final bool showBrand; // true = tampilkan tulisan "Task Zilla" (dipakai di register)

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBrand = false, // default: nggak ditampilkan
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO(Aliyah): ini masih ikon placeholder.
        // Ganti dengan gambar maskot Dino kalau asetnya sudah ada di repo.
        ClipOval(
        child: Image.asset(
          'assets/logo_taskzilla.jpeg',
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          // Kalau gambar tidak ketemu, tampilkan ikon default yang masih plan supaya tidak error merah.
          errorBuilder: (_, _, _) => Container(
            width: 64,
            height: 64,
            color: const Color(0xFFD1FAF4),
            child: const Icon(
              Icons.task_alt_rounded,
              color: AuthStyle.primary,
              size: 34,
            ),
          ),
        ),
      ),
        const SizedBox(height: 12), // spasi kosong setinggi 12

        // `if (...) ...[ ]` = tampilkan bagian ini HANYA kalau showBrand true.
        if (showBrand) ...[
          // Text.rich dipakai biar satu teks bisa punya 2 warna:
          // "Task " warna gelap, "Zilla" warna teal.
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Task ',
                  style: TextStyle(color: AuthStyle.textDark),
                ),
                TextSpan(
                  text: 'Zilla',
                  style: TextStyle(color: AuthStyle.primary),
                ),
              ],
            ),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
        ],

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700, // w700 = tebal (bold)
            color: AuthStyle.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4, // jarak antar baris biar nggak terlalu rapat
            color: AuthStyle.textGrey,
          ),
        ),
      ],
    );
  }
}

/// Kolom input standar: ada label di atas, ikon di kiri, dan (kalau password)
/// tombol mata untuk lihat/sembunyikan isi.
///
/// Kenapa StatefulWidget? Karena dia perlu "ingat" apakah password lagi
/// disembunyikan atau tidak (_obscure), dan datanya bisa berubah saat
/// tombol mata ditekan. Widget yang datanya berubah = Stateful.
class AuthTextField extends StatefulWidget {
  final String label; // tulisan di atas kolom, misal "Email"
  final String hint; // teks abu-abu di dalam kolom (placeholder)
  final IconData prefixIcon; // ikon di sisi kiri
  final TextEditingController controller; // "kendali" untuk baca/ubah isi kolom
  final bool isPassword; // true = isi disamarkan jadi titik-titik
  final bool enabled; // false = kolom dikunci (dipakai saat loading)
  final TextInputType keyboardType; // jenis keyboard (email, teks, dll)
  final TextInputAction textInputAction; // tombol enter: "next" atau "done"
  final String? Function(String?)? validator; // fungsi pengecek isi kolom
  final ValueChanged<String>? onChanged; // dipanggil tiap isi kolom berubah
  final ValueChanged<String>? onSubmitted; // dipanggil saat tekan enter/done

  /// Widget kecil di kanan label, misalnya link "Lupa kata sandi?".
  /// Boleh kosong (nullable).
  final Widget? labelAction;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.labelAction,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  // `late` = nilainya diisi belakangan, tapi pasti terisi sebelum dipakai.
  // Awalnya: kalau kolom ini password, isinya langsung disembunyikan.
  late bool _obscure = widget.isPassword;

  // Fungsi bantu supaya nggak nulis ulang bentuk garis tepi 5 kali.
  // Cuma beda warna: biasa, fokus, atau error.
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthStyle.radius),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
      children: [
        // Baris label: [Label ........ labelAction]
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AuthStyle.textDark,
                ),
              ),
            ),
            if (widget.labelAction != null) widget.labelAction!,
          ],
        ),
        const SizedBox(height: 6),

        // TextFormField = kolom input yang "ngerti" Form, jadi bisa divalidasi
        // otomatis lewat formKey.currentState.validate().
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: const TextStyle(fontSize: 14, color: AuthStyle.textDark),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 13, color: AuthStyle.hint),
            filled: true,
            fillColor: AuthStyle.fieldFill,
            isDense: true, // bikin tinggi kolom lebih ringkas
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            prefixIcon: Icon(widget.prefixIcon, size: 18, color: AuthStyle.hint),

            // Tombol mata cuma muncul kalau ini kolom password.
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined // lagi disembunyikan
                          : Icons.visibility_outlined, // lagi kelihatan
                      size: 18,
                      color: AuthStyle.hint,
                    ),
                    // setState = kasih tahu Flutter "datanya berubah, gambar ulang!"
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,

            // Garis tepi untuk tiap kondisi kolom
            enabledBorder: _border(AuthStyle.border),
            disabledBorder: _border(AuthStyle.border),
            focusedBorder: _border(AuthStyle.primary), // saat diklik: teal
            errorBorder: _border(AuthStyle.error), // saat salah: merah
            focusedErrorBorder: _border(AuthStyle.error),
            errorStyle: const TextStyle(fontSize: 11, color: AuthStyle.error),
          ),
        ),
      ],
    );
  }
}

/// Tombol utama (warna teal) dengan panah di kanan.
/// Kalau [isLoading] true, teksnya diganti lingkaran muter dan tombol
/// nggak bisa ditekan lagi (biar user nggak klik dua kali).
class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // fungsi yang dijalankan saat ditekan
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // selebar layar (sesuai area yang tersedia)
      height: 48,
      child: ElevatedButton(
        // onPressed null = tombol otomatis nonaktif
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthStyle.primary,
          foregroundColor: Colors.white,
          // Warna saat nonaktif disamakan, biar saat loading tombol
          // tetap teal (nggak berubah jadi abu-abu).
          disabledBackgroundColor: AuthStyle.primary,
          disabledForegroundColor: Colors.white,
          elevation: 0, // tanpa bayangan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthStyle.radius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

/// Garis kecil di bawah kolom password (layar register) yang nunjukin
/// seberapa kuat password yang lagi diketik.
///
/// Warnanya:
///   merah   = belum sampai 8 karakter
///   oranye  = "Cukup"
///   teal    = "Kuat"
class PasswordStrengthBar extends StatelessWidget {
  final String password; // isi password saat ini
  final int minLength;

  const PasswordStrengthBar({
    super.key,
    required this.password,
    this.minLength = 8,
  });

  @override
  Widget build(BuildContext context) {
    final score = AuthValidators.passwordStrength(password); // 0..4
    final tooShort = password.length < minLength;

    // Tentukan warna & teks berdasarkan kondisi password.
    final Color color;
    final String label;
    if (tooShort) {
      color = AuthStyle.error;
      label = 'Minimal $minLength karakter';
    } else if (score <= 2) {
      color = AuthStyle.warning;
      label = 'Cukup';
    } else {
      color = AuthStyle.primary;
      label = 'Kuat';
    }

    // Panjang bar: 0 kalau kosong, selain itu skor/4 (minimal 1/4 biar kelihatan).
    final progress = password.isEmpty ? 0.0 : (score.clamp(1, 4)) / 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // teks status rata kanan
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AuthStyle.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            // kalau masih kosong, teksnya abu-abu aja (belum ada penilaian)
            color: password.isEmpty ? AuthStyle.hint : color,
          ),
        ),
      ],
    );
  }
}