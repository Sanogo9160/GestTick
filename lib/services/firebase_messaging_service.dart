import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void init() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Traitez les notifications reçues ici
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message notification: ${message.notification}');
        // Affichez une notification locale ou un autre traitement
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Traitez les notifications lorsqu'elles sont ouvertes
      print('Message clicked! ${message.data}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }
}
