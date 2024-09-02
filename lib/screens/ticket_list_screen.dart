import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/screens/edit_ticket_screen.dart';
import 'package:gesttick/screens/ticket_details_screen.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/widgets/ticket_card.dart';  //Import du widget TicketCard

class TicketListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getTickets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tickets = snapshot.data!.docs.map((doc) => Ticket.fromDocument(doc)).toList();

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];

              return TicketCard(
                ticket: ticket,
                onTap: () {
                  print('View ticket: ${ticket.title}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(ticket: ticket),
                    ),
                  );
                },
                onEdit: () {
                  print('Edit ticket: ${ticket.title}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTicketScreen(ticket: ticket),
                    ),
                  );
                },
                onDelete: () async {
                  print('Delete ticket: ${ticket.title}');
                  try {
                    await _firestoreService.deleteTicket(ticket.id);
                    // Refresh the list after deletion
                  } catch (e) {
                    print('Error deleting ticket: $e');
                  }
                },
                onView: () {
                  print('View ticket: ${ticket.title}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(ticket: ticket),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
