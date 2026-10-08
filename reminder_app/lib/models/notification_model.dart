import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String taskId;
  final String message;
  final Timestamp scheduledAt;
  final bool isRead;
  final Timestamp? createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.message,
    required this.scheduledAt,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return NotificationModel(
      id: documentId,
      userId: map['userId'] ?? '',
      taskId: map['taskId'] ?? '',
      message: map['message'] ?? '',
      scheduledAt: map['scheduledAt'],
      isRead: map['isRead'] ?? false,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'taskId': taskId,
      'message': message,
      'scheduledAt': scheduledAt,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
