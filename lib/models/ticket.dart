import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String id;
  String title;
  String description;
  String status; // 'Attente', 'En cours', 'Résolu'
  String category; // 'Technique', 'Pédagogique'
  Timestamp createdAt;
  Timestamp updatedAt;
  String studentId;
  String trainerId;
  

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.studentId,
    required this.trainerId,
     
  });

  factory Ticket.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'Attente',
      category: data['category'] ?? '',
      createdAt: data['createdAt'] as Timestamp,
      updatedAt: data['updatedAt'] as Timestamp,
      studentId: data['studentId'] ?? '',
      trainerId: data['trainerId'] ?? '',
     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'studentId': studentId,
      'trainerId': trainerId,
    };
  }

 // Methode pour afficher les ticket reccent
   bool isRecent() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));

    // Convert Timestamp to DateTime
    final createdAtDateTime = createdAt.toDate();
    return createdAtDateTime.isAfter(sevenDaysAgo);
  }

   // la méthode copyWith
  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? category,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? studentId,
    String? trainerId,
   
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      studentId: studentId ?? this.studentId,
      trainerId: trainerId ?? this.trainerId,
      
    );
  }




}



