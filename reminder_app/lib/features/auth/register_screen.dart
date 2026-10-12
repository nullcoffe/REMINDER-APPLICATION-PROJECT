// =============================================================================
// register_screen.dart  (PIC: Laili)
// Referensi desain Figma: "03 Register"
// Layar daftar akun baru: isi email, password, konfirmasi password.
// Ada bar kecil yang nunjukin kekuatan password secara langsung.
//
// Sudah tersambung ke AuthProvider (buatan Bintoro) lewat _onRegisterPressed().
// Kalau daftar sukses, user otomatis login (Firebase) dan dipindah ke dashboard.
// =============================================================================

// Semua widget Flutter datang dari sini.
import 'package:flutter/material.dart';

// Provider: dipakai untuk mengambil AuthProvider lewat context.read<...>().
import 'package:provider/provider.dart';

// Daftar nama rute aplikasi (buatan Aliyah), dipakai pindah ke dashboard.
import '../../app/routes/app_routes.dart';

// State auth (buatan Bintoro): register(), isLoading, errorMessage.
import '../../providers/auth_provider.dart';

// Layar login, dipakai buat balik ke login kalau register dibuka tanpa
// tumpukan halaman sebelumnya (lihat _goToLogin).
import 'login_screen.dart';

// "Kotak perkakas" file auth buatan Laili.
import 'widgets/auth_form_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Kunci Form: dipakai buat validasi semua kolom sekaligus.
  final _formKey = GlobalKey<FormState>();

  // Controller untuk membaca isi masing-masing kolom.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false; // true = lagi proses daftar

  /// Buang controller saat layar ditutup, biar memori nggak bocor.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Dijalankan saat tombol "Daftar Sekarang" ditekan.
  Future<void> _onRegisterPressed() async {
    // 1. Tutup keyboard.
    FocusScope.of(context).unfocus();

    // 2. Validasi semua kolom. Kalau ada yang salah, berhenti di sini.
    if (!_formKey.currentState!.validate()) return;

    // 3. Tampilkan loading.
    setState(() => _isLoading = true);

    // 4. Panggil AuthProvider.register(). Hasilnya true (sukses) atau false.
    //    Catatan: AuthService menolak email selain domain .ac.id, jadi email
    //    non-kampus akan gagal di tahap ini walau lolos validasi form.
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // 5. Baca pesan error SEKARANG, sebelum pindah layar.
    final error = auth.errorMessage;

    // 6. Pastikan layar masih ada sebelum setState (user mungkin sudah pindah).
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showMessage('Akun berhasil dibuat');
      // Firebase otomatis memasukkan user ke sesi login setelah daftar,
      // jadi langsung ke dashboard dan hapus layar sebelumnya dari tumpukan.
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.dashboard,
        (route) => false,
      );
    } else {
      _showMessage(error ?? 'Pendaftaran gagal. Silakan coba lagi.');
    }
  }

  /// Kembali ke layar login.
  ///
  /// - Kalau register dibuka dari login (lewat push), cukup `pop`
  ///   (tutup layar ini, otomatis kelihatan login di bawahnya).
  /// - Kalau register adalah layar pertama (nggak ada yang bisa di-pop),
  ///   ganti layar ini dengan LoginScreen.
  void _goToLogin() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  /// Pesan singkat di bagian bawah layar (SnackBar).
  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  /// Menggambar tampilan layar. Urutan (atas ke bawah):
  /// header -> email -> password -> bar kekuatan -> konfirmasi
  /// -> tombol -> link ke login.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthStyle.background,
      body: SafeArea(
        // SafeArea: isi nggak ketutup notch / status bar.
        child: Center(
          child: SingleChildScrollView(
            // Biar bisa di-scroll saat keyboard muncul.
            padding: const EdgeInsets.all(AuthStyle.pagePadding),
            child: ConstrainedBox(
              // Batasi lebar maksimal supaya rapi di layar lebar.
              constraints: const BoxConstraints(
                maxWidth: AuthStyle.maxContentWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Header (showBrand: true = ada tulisan "Task Zilla") ---
                    const AuthHeader(
                      showBrand: true,
                      title: 'Daftar Akun Baru',
                      subtitle: 'Mulai kelola tugas kuliah dan deadline '
                          'lebih teratur bersama TaskZilla',
                    ),
                    const SizedBox(height: 28),

                    // --- Email ---
                    // TODO: AuthService hanya menerima email .ac.id. Kalau tim
                    // memutuskan tetap wajib .ac.id, ganti validator di bawah
                    // dengan validator khusus kampus supaya error muncul di form.
                    AuthTextField(
                      label: 'Email',
                      hint: 'cth: nama@gmail.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                      validator: AuthValidators.email,
                    ),
                    const SizedBox(height: 16),

                    // --- Password ---
                    AuthTextField(
                      label: 'Kata Sandi',
                      hint: 'Minimal 8 karakter',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      isPassword: true,
                      enabled: !_isLoading,
                      validator: AuthValidators.password,
                      // Tiap kali user ngetik, gambar ulang layar supaya
                      // bar kekuatan di bawahnya ikut ter-update.
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),

                    // --- Bar kekuatan password (membaca isi kolom di atas) ---
                    PasswordStrengthBar(password: _passwordController.text),
                    const SizedBox(height: 16),

                    // --- Konfirmasi password ---
                    AuthTextField(
                      label: 'Konfirmasi Kata Sandi',
                      hint: 'Ulangi kata sandi',
                      prefixIcon: Icons.verified_user_outlined,
                      controller: _confirmController,
                      isPassword: true,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      // Tekan Enter di keyboard = sama dengan tekan tombol Daftar.
                      onSubmitted: (_) => _onRegisterPressed(),
                      // Dibandingkan dengan isi kolom password di atas.
                      validator: (v) => AuthValidators.confirmPassword(
                        v,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Tombol Daftar ---
                    AuthButton(
                      label: 'Daftar Sekarang',
                      isLoading: _isLoading,
                      onPressed: _onRegisterPressed,
                    ),
                    const SizedBox(height: 20),

                    // --- Link ke login ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AuthStyle.textGrey,
                          ),
                        ),
                        GestureDetector(
                          // Saat loading, link dimatikan (onTap null).
                          onTap: _isLoading ? null : _goToLogin,
                          child: const Text(
                            'Masuk di sini',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AuthStyle.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}