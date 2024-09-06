import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gesttick/models/notification.dart';

class NotificationsScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('notifications').orderBy('createdAt', descending: true).snapshots(), // Utilisez 'createdAt' au lieu de 'timestamp'
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading notifications'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications available'));
          }

          // Convertissez les documents Firestore en objets NotificationModel
          final notifications = snapshot.data!.docs.map((doc) {
            return NotificationModel.fromFirestore(doc.data() as DocumentSnapshot<Object?>);
          }).toList();

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                color: Colors.blue.shade50, // Couleur personnalisée
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.notifications, color: Colors.blue), // Icône personnalisée
                  title: Text(
                    notification.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(notification.body), // Utilisez 'body' au lieu de 'message'
                  trailing: Text(timeago.format(notification.createdAt)), // Formatage de la date
                ),
              );
            },
          );
        },
      ),
    );
  }
}
