import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';

// Melakukan logout dari Firebase, lalu kembali ke halaman login
// dan menghapus seluruh riwayat halaman.
Future<void> jalankanLogout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  if (!context.mounted) return;
  Navigator.of(context).pushNamedAndRemoveUntil(
    AppRoutes.login,
    (route) => false,
  );
}