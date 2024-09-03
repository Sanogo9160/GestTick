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

  // Méthode pour convertir un document Firestore en objet Notification
  factory NotificationModel.fromFirestore(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'],
      title: data['title'],
      body: data['body'],
      userId: data['userId'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  // Méthode pour convertir un objet Notification en Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
