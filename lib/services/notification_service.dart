// lib/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Méthode pour configurer les notifications
  Future<void> initialize() async {
    // Configuration des paramètres de notification
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Gestion des messages en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu en premier plan: ${message.messageId}');
      // Ajouter la logique pour afficher une notification en premier plan
    });

    // Gestion des messages lorsque l'application est en arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message ouvert à partir de l\'arrière-plan: ${message.messageId}');
      // Ajouter la logique pour naviguer vers un écran spécifique
    });

    // Obtenir le token FCM du périphérique
    String? token = await _firebaseMessaging.getToken();
    print('Token FCM du périphérique: $token');
  }

  // Méthode pour envoyer une notification (à utiliser côté serveur)
  Future<void> sendNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    // Note: Cette méthode est généralement utilisée côté serveur pour envoyer des notifications.
    // Vous devrez utiliser Firebase Cloud Messaging API pour envoyer des notifications.
    print('Envoi de notification avec titre: $title et corps: $body');
    // Code pour envoyer la notification via FCM API
  }
}
