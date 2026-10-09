import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';


class CategoryService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Tambah kategori
  Future<void> createCategory(
    CategoryModel category,
  ) async {

    await _firestore
        .collection('categories')
        .doc(category.id)
        .set(
          category.toMap(),
        );

  }

  // Ambil semua kategori user
  Stream<List<CategoryModel>> getCategories(
    String userId,
  ) {

    return _firestore
        .collection('categories')
        .where(
          'userId',
          isEqualTo: userId,
        )
        .snapshots()
        .map(
          (snapshot) {

            return snapshot.docs
                .map(
                  (doc) => CategoryModel.fromMap(
                    doc.data(),
                    doc.id,
                  ),
                )
                .toList();

          },
        );

  }

  // Update kategori
  Future<void> updateCategory(
    CategoryModel category,
  ) async {

    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(
          category.toMap(),
        );

  }

  // Hapus kategori
  Future<void> deleteCategory(
    String categoryId,
  ) async {

    await _firestore
        .collection('categories')
        .doc(categoryId)
        .delete();

  }

}