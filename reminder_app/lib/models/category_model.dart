import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String userId;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;


  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });


  factory CategoryModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return CategoryModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}