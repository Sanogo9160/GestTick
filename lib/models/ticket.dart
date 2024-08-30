import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String id;
  String title;
  String description;
  String category;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String studentId;
  String trainerId;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.studentId,
    required this.trainerId,
  });

  factory Ticket.fromMap(Map<String, dynamic> data) {
    return Ticket(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'Attente',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      studentId: data['studentId'] ?? '',
      trainerId: data['trainerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'studentId': studentId,
      'trainerId': trainerId,
    };
  }
}
