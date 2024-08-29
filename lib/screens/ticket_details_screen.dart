import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String ticketId;

  TicketDetailsScreen({required this.ticketId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Ticket'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('tickets').doc(ticketId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Ticket non trouvé.'));
          }

          final ticket = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Titre: ${ticket['titre']}', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 10),
                Text('Description: ${ticket['description']}', style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 10),
                Text('Statut: ${ticket['status']}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
