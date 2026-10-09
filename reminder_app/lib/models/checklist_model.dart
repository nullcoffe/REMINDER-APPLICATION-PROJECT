import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistModel {
  final String id;
  final String taskId;
  final String itemTitle;
  final bool isCompleted;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  ChecklistModel({
    required this.id,
    required this.taskId,
    required this.itemTitle,
    required this.isCompleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ChecklistModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ChecklistModel(
      id: documentId,
      taskId: map['taskId'] ?? '',
      itemTitle: map['itemTitle'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'itemTitle': itemTitle,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
