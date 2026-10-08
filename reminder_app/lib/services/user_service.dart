import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';


class UserService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Mengambil data user berdasarkan UID
  Future<UserModel?> getUser(String uid) async {

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .get();


    if (snapshot.exists) {

      return UserModel.fromMap(
        snapshot.data()!,
        snapshot.id,
      );

    }

    return null;
  }



  // Membuat user baru
  Future<void> createUser(UserModel user) async {

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
          user.toMap(),
        );
  }



  // Update data user
  Future<void> updateUser(UserModel user) async {

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(
          user.toMap(),
        );
  }



  // Hapus user
  Future<void> deleteUser(String uid) async {

    await _firestore
        .collection('users')
        .doc(uid)
        .delete();

  }

}