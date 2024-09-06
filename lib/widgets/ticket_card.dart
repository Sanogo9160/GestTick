import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gesttick/services/firestore_service.dart';

class TicketCard extends StatefulWidget {
  final String ticketId;
  final String initialStatus;

  TicketCard({required this.ticketId, required this.initialStatus});

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;

    // Listen for ticket status updates
    _listenToTicketStatus();
  }

  void _listenToTicketStatus() {
    // Listen to ticket status updates from Firestore
    FirestoreService().getTicketStatus(widget.ticketId).listen((status) {
      setState(() {
        _status = status;
      });
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En Cours':
        return Colors.blue;
      case 'Résolu':
        return Colors.green;
      case 'En attente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getStatusColor(_status),
      child: ListTile(
        title: Text('Ticket ID: ${widget.ticketId}'),
        subtitle: Text('Statut: $_status'),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Simulate status change
            _updateTicketStatus('Nouvel État');
          },
        ),
      ),
    );
  }

  Future<void> _updateTicketStatus(String newStatus) async {
    try {
      await FirestoreService().updateTicketStatus(widget.ticketId, newStatus);
    } catch (e) {
      print('Erreur lors de la mise à jour du statut : $e');
    }
  }
}
