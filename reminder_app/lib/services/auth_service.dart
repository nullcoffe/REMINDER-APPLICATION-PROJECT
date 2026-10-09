import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Mengambil informasi pengguna yang sedang login
  User? get currentUser => _firebaseAuth.currentUser;

  // Memantau perubahan status login
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  // Fungsi login
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email dan kata sandi wajib diisi.',
      );
    }

    return await _firebaseAuth.signInWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
  }

  // Fungsi register
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email dan kata sandi wajib diisi.',
      );
    }

    // Validasi email mahasiswa dengan domain .ac.id
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.ac\.id$');

    if (!emailRegex.hasMatch(cleanEmail)) {
      throw FirebaseAuthException(
        code: 'invalid-email-domain',
        message: 'Gunakan email mahasiswa dengan domain .ac.id.',
      );
    }

    if (password.length < 8) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Kata sandi minimal 8 karakter.',
      );
    }

    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
  }

  // Fungsi logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}