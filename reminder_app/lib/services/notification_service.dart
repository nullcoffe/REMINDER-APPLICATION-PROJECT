import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  // Menghubungkan aplikasi dengan Cloud Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil koleksi notifikasi milik pengguna.
  CollectionReference<Map<String, dynamic>> _userNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications');
  }

  // Mengambil daftar notifikasi terbaru milik pengguna.
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications(String userId) {
    return _userNotifications(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Menghitung jumlah notifikasi yang belum dibaca.
  Stream<int> getUnreadCount(String userId) {
    return _userNotifications(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Menandai notifikasi sebagai sudah dibaca.
  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    await _userNotifications(userId)
        .doc(notificationId)
        .update({'isRead': true});
  }
}
