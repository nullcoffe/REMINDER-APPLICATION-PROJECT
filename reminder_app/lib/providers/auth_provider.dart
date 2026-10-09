import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  late final StreamSubscription<User?> _authSubscription;

  AuthProvider() {
    _user = _authService.currentUser;

    _authSubscription = _authService.authStateChanges.listen(
      (User? user) {
        _user = user;
        notifyListeners();
      },
      onError: (Object error) {
        _errorMessage = 'Gagal memantau status login.';
        notifyListeners();
      },
    );
  }

  // Mengambil data pengguna yang sedang login
  User? get user => _user;

  // Memeriksa apakah pengguna sudah login
  bool get isLoggedIn => _user != null;

  // Memeriksa apakah proses login atau register sedang berlangsung
  bool get isLoading => _isLoading;

  // Mengambil pesan error
  String? get errorMessage => _errorMessage;

  // Login menggunakan email dan password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      await _authService.login(
        email: email,
        password: password,
      );

      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register menggunakan email dan password
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      await _authService.register(
        email: email,
        password: password,
      );

      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout dari aplikasi
  Future<bool> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _errorMessage = null;
      return true;
    } catch (_) {
      _errorMessage = 'Gagal logout. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Mengatur status loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Mengubah error Firebase menjadi pesan yang mudah dipahami
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'empty-fields':
        return 'Email dan kata sandi wajib diisi.';

      case 'invalid-email-domain':
        return 'Gunakan email mahasiswa dengan domain .ac.id.';

      case 'weak-password':
        return 'Kata sandi minimal 8 karakter.';

      case 'invalid-email':
        return 'Format email tidak valid.';

      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'Email atau kata sandi salah.';

      case 'email-already-in-use':
        return 'Email sudah terdaftar.';

      case 'network-request-failed':
        return 'Periksa koneksi internet kamu.';

      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';

      default:
        return e.message ?? 'Autentikasi gagal. Silakan coba lagi.';
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}