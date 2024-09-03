import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Initialisation de Firebase Messaging
  Future<void> initialize() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu: ${message.notification?.title}, ${message.notification?.body}');
      // Gérer la réception du message ici
    });
  }

  // Envoyer une notification
  Future<void> sendNotification(String title, String body, String userId) async {
    // Intégrer l'envoi de notification via Firebase Cloud Messaging ici
  }
}
