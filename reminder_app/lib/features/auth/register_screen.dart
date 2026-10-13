import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import 'login_screen.dart';
import 'widgets/auth_form_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    final error = auth.errorMessage;

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showMessage('Akun berhasil dibuat');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
    } else {
      _showMessage(error ?? 'Pendaftaran gagal. Silakan coba lagi.');
    }
  }

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

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.authMaxContentWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      showBrand: true,
                      title: 'Buat Akun Baru',
                      subtitle:
                          'Mulai atur jadwal dan deadline tanpa panik '
                          'bareng TaskZilla!',
                    ),
                    const SizedBox(height: 28),
                    AuthTextField(
                      label: AppStrings.emailLabel,
                      hint: 'cth: nama@gmail.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                      validator: AuthValidators.email,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: AppStrings.passwordLabel,
                      hint: 'Minimal 8 karakter',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      isPassword: true,
                      enabled: !_isLoading,
                      validator: AuthValidators.password,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    PasswordStrengthBar(password: _passwordController.text),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Konfirmasi Kata Sandi',
                      hint: 'Ulangi kata sandi',
                      prefixIcon: Icons.verified_user_outlined,
                      controller: _confirmController,
                      isPassword: true,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onRegisterPressed(),
                      validator: (v) => AuthValidators.confirmPassword(
                        v,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthButton(
                      label: AppStrings.registerButton,
                      isLoading: _isLoading,
                      onPressed: _onRegisterPressed,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _goToLogin,
                          child: const Text(
                            'Masuk di sini',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTeal,
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
