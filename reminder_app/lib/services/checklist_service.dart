import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/checklist_model.dart';


class ChecklistService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;



  // Tambah checklist
  Future<void> createChecklist(
    ChecklistModel checklist,
  ) async {

    await _firestore
        .collection('checklist')
        .doc(checklist.id)
        .set(
          checklist.toMap(),
        );

  }



  // Ambil checklist berdasarkan task
  Stream<List<ChecklistModel>> getChecklist(
    String taskId,
  ) {

    return _firestore
        .collection('checklist')
        .where(
          'taskId',
          isEqualTo: taskId,
        )
        .snapshots()
        .map(
          (snapshot) {

            return snapshot.docs
                .map(
                  (doc) => ChecklistModel.fromMap(
                    doc.data(),
                    doc.id,
                  ),
                )
                .toList();

          },
        );

  }



  // Update checklist
  Future<void> updateChecklist(
    ChecklistModel checklist,
  ) async {

    await _firestore
        .collection('checklist')
        .doc(checklist.id)
        .update(
          checklist.toMap(),
        );

  }



  // Hapus checklist
  Future<void> deleteChecklist(
    String checklistId,
  ) async {

    await _firestore
        .collection('checklist')
        .doc(checklistId)
        .delete();

  }

}