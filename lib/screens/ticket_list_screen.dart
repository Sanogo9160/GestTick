import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/screens/edit_ticket_screen.dart';
import 'package:gesttick/screens/ticket_details_screen.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/widgets/ticket_card.dart';  // Import du widget TicketCard

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          }

          final tickets = snapshot.data?.docs.map((doc) => Ticket.fromDocument(doc)).toList() ?? [];

          if (tickets.isEmpty) {
            return _buildEmptyState();
          }

          return _buildTicketList(tickets, context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTicketScreen(), // Pour créer un nouveau ticket
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Ajouter un Ticket',
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Text(
        'Erreur de chargement des tickets : $error',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text('Aucun ticket à afficher.'),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets, BuildContext context) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return TicketCard(
          ticket: ticket,
          onTap: () {
            _viewTicket(ticket, context);
          },
          onEdit: () {
            _editTicket(ticket, context);
          },
          onDelete: () async {
            await _deleteTicket(ticket, context);
          },
          onView: () {
            _viewTicket(ticket, context);
          },
        );
      },
    );
  }

  void _viewTicket(Ticket ticket, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailScreen(ticket: ticket),
      ),
    );
  }

  void _editTicket(Ticket ticket, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTicketScreen(ticket: ticket), // Passer le ticket à modifier
      ),
    );
  }

  Future<void> _deleteTicket(Ticket ticket, BuildContext context) async {
    try {
      await _firestoreService.deleteTicket(ticket.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket supprimé avec succès.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du ticket : $e')),
      );
    }
  }
}
