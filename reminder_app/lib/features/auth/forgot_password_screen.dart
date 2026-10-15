import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

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
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = "Email tidak boleh kosong");
      return;
    }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _success ? _successView() : _formView(),
        ),
      ),
    );
  }

  Widget _formView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            "Masukkan email akun kamu untuk menerima link reset password",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!_loading) _sendResetEmail();
            },
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 15),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _sendResetEmail,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Kirim Link Reset"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _successView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.mark_email_read,
          size: 70,
          color: Colors.green,
        ),
        const SizedBox(height: 20),
        Text(
          "Link reset password telah dikirim ke:\n\n$_sentEmail",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          "Tidak ketemu? Cek juga folder spam.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Kembali Login"),
        ),
      ],
    );
  }
}