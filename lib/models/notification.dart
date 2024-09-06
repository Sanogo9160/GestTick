import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String title;
  String body;
  String userId;
  DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.createdAt,
  });

  // Méthode pour convertir un document Firestore en objet NotificationModel
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return NotificationModel(
      id: doc.id, // Utilisation de l'ID du document Firestore
      title: data['title'] ?? '', // Valeur par défaut si null
      body: data['body'] ?? '',   // Valeur par défaut si null
      userId: data['userId'] ?? '', // Valeur par défaut si null
      createdAt: (data['createdAt'] as Timestamp).toDate(), // Conversion de Timestamp à DateTime
    );
  }

  // Méthode pour convertir un objet NotificationModel en Map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt), // Conversion de DateTime à Timestamp
    };
  }
}
