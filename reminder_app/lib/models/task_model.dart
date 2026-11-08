import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String userId;
  final Timestamp deadline;
  final String difficultyLevel;
  final int priorityScore;
  final String status;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.userId,
    required this.deadline,
    required this.difficultyLevel,
    required this.priorityScore,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      userId: map['userId'] ?? '',
      deadline: map['deadline'],
      difficultyLevel: map['difficultyLevel'] ?? '',
      priorityScore: map['priorityScore'] ?? 0,
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'userId': userId,
      'deadline': deadline,
      'difficultyLevel': difficultyLevel,
      'priorityScore': priorityScore,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    String? userId,
    Timestamp? deadline,
    String? difficultyLevel,
    int? priorityScore,
    String? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      deadline: deadline ?? this.deadline,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      priorityScore: priorityScore ?? this.priorityScore,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
