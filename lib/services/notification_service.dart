import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Demander la permission aux utilisateurs
    NotificationSettings settings = await _fcm.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission granted for notifications');
    }

    // Gérer les notifications reçues quand l'application est en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
    });

    // Gérer les notifications lorsque l'application est en arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.data}');
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }
}
