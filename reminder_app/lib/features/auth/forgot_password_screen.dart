import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _success = false;
  String? _errorMessage;
  String _sentEmail = "";

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      setState(() {
        _sentEmail = email;
        _success = true;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            _errorMessage = "Format email tidak valid";
            break;
          case 'user-not-found':
            _errorMessage = "Email tidak terdaftar";
            break;
          case 'too-many-requests':
            _errorMessage = "Terlalu banyak percobaan, coba lagi nanti";
            break;
          case 'network-request-failed':
            _errorMessage = "Tidak ada koneksi internet";
            break;
          default:
            _errorMessage = "Gagal mengirim email reset";
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = "Terjadi kesalahan, coba lagi");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Lupa Password",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Center(
            child: SingleChildScrollView(
              child: _success
                  ? _successView(colorScheme)
                  : _formView(colorScheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formView(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_reset, size: 60, color: colorScheme.primary),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            "Masukkan email akun kamu untuk menerima link reset password",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: AppSizes.fontSizeSmall,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXL),
          NeuInput(
            hintText: AppStrings.loginEmailHint,
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.fieldRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceM),
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.error,
                fontSize: AppSizes.fontSizeSmall,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
          ],
          NeuButton(
            text: _loading ? "Mengirim..." : "Kirim Link Reset",
            icon: _loading ? null : Icons.send,
            onPressed: _loading ? null : _sendResetEmail,
          ),
        ],
      ),
    );
  }

  Widget _successView(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mark_email_read, size: 70, color: colorScheme.primary),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            "Link reset password telah dikirim ke:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: AppSizes.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            _sentEmail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: AppSizes.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            "Tidak ketemu? Cek juga folder spam.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: AppSizes.fontSizeSmall,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          NeuButton(
            text: "Kembali Login",
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
