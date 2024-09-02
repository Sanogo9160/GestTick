import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  TicketDetailScreen({required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(ticket.description),
            SizedBox(height: 16),
            Text('Statut: ${ticket.status}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Catégorie: ${ticket.category}'),
            SizedBox(height: 16),
            if (ticket.status != 'Résolu') ...[
              ElevatedButton(
                onPressed: () async {
                  await _firestoreService.updateTicket(Ticket(
                    id: ticket.id,
                    title: ticket.title,
                    description: ticket.description,
                    status: 'Résolu',
                    category: ticket.category,
                    createdAt: ticket.createdAt,
                    updatedAt: Timestamp.now(),
                    studentId: ticket.studentId,
                    trainerId: ticket.trainerId,
                  ));
                  Navigator.pop(context);
                },
                child: Text('Marquer comme Résolu'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
