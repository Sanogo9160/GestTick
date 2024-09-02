// trainer_ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/models/ticket.dart';

class TrainerTicketScreen extends StatefulWidget {
  @override
  _TrainerTicketScreenState createState() => _TrainerTicketScreenState();
}

class _TrainerTicketScreenState extends State<TrainerTicketScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Ticket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    _firestoreService.getTicketsForTrainer().listen((tickets) {
      setState(() {
        _tickets = tickets;
      });
    });
  }

  void _handleTakeCharge(Ticket ticket) async {
    await _firestoreService.updateTicketStatus(ticket.id, 'En cours');
    _loadTickets(); // Recharge les tickets après modification
  }

  void _handleResolveTicket(Ticket ticket) async {
    await _firestoreService.updateTicketStatus(ticket.id, 'Résolu');
    _loadTickets(); // Recharge les tickets après modification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets en Cours'),
      ),
      body: ListView.builder(
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          return ListTile(
            title: Text(ticket.title),
            subtitle: Text(ticket.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _handleResolveTicket(ticket),
                ),
                IconButton(
                  icon: Icon(Icons.work),
                  onPressed: () => _handleTakeCharge(ticket),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
