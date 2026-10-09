// =============================================================================
// login_screen.dart  (PIC: Laili)
// Referensi desain Figma: "02B Login dengan ..."
//
// Layar login: isi email + password, lalu tekan "Masuk Sekarang".
//
// Catatan penting: layar ini BELUM nyambung ke Firebase / AuthProvider
// (itu bagian Bintoro). Jadi saat tombol ditekan, prosesnya masih simulasi.
// Titik yang nanti disambung ditandai komentar TODO di _onLoginPressed().
// =============================================================================

// Semua widget Flutter datang dari sini. Jangan sampai ketinggalan.
import 'package:flutter/material.dart';

// Layar register (tetangga satu folder), dipakai buat pindah halaman.
import 'register_screen.dart';

// "Kotak perkakas" auth: AuthStyle, AuthHeader, AuthTextField, AuthButton,
// dan AuthValidators. File ini buatan Laili sendiri, bukan punya teman lain.
import 'widgets/auth_form_helper.dart';

/// StatefulWidget karena layar ini punya data yang berubah:
/// status loading, centang "Ingat Saya", dan isi form.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Underscore di depan (_) artinya private: cuma bisa dipakai di file ini.
class _LoginScreenState extends State<LoginScreen> {
  // Kunci untuk "Form". Lewat kunci ini kita bisa nyuruh semua kolom
  // di dalam Form buat divalidasi sekaligus: _formKey.currentState!.validate()
  final _formKey = GlobalKey<FormState>();

  // Controller = "remote" untuk membaca isi kolom (misal _emailController.text).
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false; // status centang "Ingat Saya"
  bool _isLoading = false; // true = lagi proses login (tombol muter)

  /// Dipanggil otomatis saat layar ditutup.
  /// Controller harus dibuang manual biar nggak makan memori terus (memory leak).
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Dijalankan saat tombol "Masuk Sekarang" ditekan (atau tekan Enter di password).
  /// `async` karena ada proses yang perlu ditunggu (nanti: panggil server).
  Future<void> _onLoginPressed() async {
    // 1. Tutup keyboard dulu.
    FocusScope.of(context).unfocus();

    // 2. Cek semua kolom. Kalau ada yang salah, pesan merah muncul otomatis
    //    dan kita berhenti di sini (return).
    if (!_formKey.currentState!.validate()) return;

    // 3. Tampilkan loading.
    setState(() => _isLoading = true);

    // 4. Ambil isi form.
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // TODO(Bintoro): ganti bagian simulasi di bawah dengan
    //   final error = await context.read<AuthProvider>().login(email, password);
    // lalu kalau `error` tidak null, tampilkan lewat _showMessage(error).
    //
    // Sementara ini cuma simulasi: print ke console, tunggu 1 detik.
    // (Panjang password saja yang di-print, bukan isinya, demi keamanan.)
    debugPrint('Login dipanggil: $email (ingat saya: $_rememberMe)');
    debugPrint('Panjang password: ${password.length}');
    await Future.delayed(const Duration(seconds: 1));

    // 5. Cek `mounted`: pastikan layar masih ada. Kalau user keburu pindah
    //    halaman selama menunggu, setState di layar yang sudah hilang bisa error.
    if (!mounted) return;

    // 6. Matikan loading.
    setState(() => _isLoading = false);

    // TODO(Aliyah): pindah ke dashboard lewat AppRoutes kalau login sukses.
    _showMessage('Login berhasil (simulasi)');
  }

  /// Dipanggil saat link "Lupa kata sandi?" ditekan.
  void _onForgotPasswordPressed() {
    // TODO: bikin alur reset password kalau fiturnya jadi dipakai
    // (cek dulu di FeatureFlags buatan Alya).
    _showMessage('Fitur lupa kata sandi segera hadir');
  }

  /// Pindah ke layar register. `push` = layar baru ditumpuk di atas layar ini,
  /// jadi tombol back otomatis balik ke login.
  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  /// Tampilkan pesan singkat di bagian bawah layar (SnackBar).
  /// hideCurrentSnackBar dulu biar pesan lama nggak numpuk.
  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  /// Bagian yang menggambar tampilan layar.
  /// Urutan susunan (atas ke bawah): header -> email -> password
  /// -> ingat saya -> tombol -> link daftar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthStyle.background,
      // SafeArea: biar isi nggak ketutup notch / status bar.
      body: SafeArea(
        child: Center(
          // SingleChildScrollView: biar layar bisa di-scroll saat keyboard
          // muncul atau di HP berlayar kecil (nggak overflow).
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AuthStyle.pagePadding),
            // Batasi lebar maksimal, biar di web/tablet form nggak melebar.
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AuthStyle.maxContentWidth),
              // Form = pembungkus semua kolom input supaya bisa divalidasi bareng.
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Header: logo + judul + subjudul ---
                    const AuthHeader(
                      title: 'Masuk ke Akun Anda',
                      subtitle: 'Lanjutkan kelola tugas dan jadwal kuliah '
                          'dengan akun TaskZilla yang sudah terdaftar.',
                    ),
                    const SizedBox(height: 28),

                    // --- Kolom email ---
                    AuthTextField(
                      label: 'Email',
                      hint: 'cth: nama@gmail.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading, // dikunci saat loading
                      validator: AuthValidators.email,
                    ),
                    const SizedBox(height: 16),

                    // --- Kolom password + link "Lupa kata sandi?" ---
                    AuthTextField(
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandi',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      isPassword: true,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      // Tekan Enter di keyboard = sama dengan tekan tombol Masuk.
                      onSubmitted: (_) => _onLoginPressed(),
                      // Di login cukup cek tidak kosong. Aturan "minimal 8 karakter"
                      // cuma di register; di sini nggak perlu, biar akun lama
                      // tetap bisa login.
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Kata sandi tidak boleh kosong'
                          : null,
                      labelAction: GestureDetector(
                        onTap: _onForgotPasswordPressed,
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AuthStyle.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- Checkbox "Ingat Saya" ---
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AuthStyle.primary,
                            // onChanged null = checkbox nonaktif (saat loading).
                            onChanged: _isLoading
                                ? null
                                : (v) =>
                                    setState(() => _rememberMe = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Ingat Saya di perangkat ini',
                            style: TextStyle(fontSize: 12, color: AuthStyle.textGrey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Tombol Masuk ---
                    AuthButton(
                      label: 'Masuk Sekarang',
                      isLoading: _isLoading,
                      onPressed: _onLoginPressed,
                    ),
                    const SizedBox(height: 20),

                    // --- Link ke register ---
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(fontSize: 12, color: AuthStyle.textGrey),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _goToRegister,
                          child: const Text(
                            'Daftar sekarang',
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