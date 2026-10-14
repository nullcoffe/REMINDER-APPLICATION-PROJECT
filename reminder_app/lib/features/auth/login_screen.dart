import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import 'widgets/auth_form_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.dashboard,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      String errorMsg = e.toString().replaceFirst('Exception: ', '');
      _showMessage(errorMsg);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onForgotPasswordPressed() {
    _showMessage('Fitur lupa kata sandi segera hadir');
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
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
                      title: 'Masuk ke Akun Anda',
                      subtitle: 'Lanjutkan kelola tugas dan jadwal kuliah '
                          'dengan akun TaskZilla yang sudah terdaftar.',
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
                      hint: 'Masukkan kata sandi',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      isPassword: true,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onLoginPressed(),
                      validator: (v) => (v == null || v.isEmpty)
                          ? AppStrings.fieldRequired
                          : null,
                      labelAction: GestureDetector(
                        onTap: _onForgotPasswordPressed,
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primaryTeal,
                            onChanged: _isLoading
                                ? null
                                : (v) => setState(() => _rememberMe = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Ingat Saya di perangkat ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AuthButton(
                      label: AppStrings.loginButton,
                      isLoading: _isLoading,
                      onPressed: _onLoginPressed,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _goToRegister,
                          child: Text(
                            AppStrings.registerButton,
                            style: const TextStyle(
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