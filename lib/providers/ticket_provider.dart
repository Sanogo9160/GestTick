import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';

class TicketProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  Future<void> fetchTickets() async {
    _firestoreService.getTicketsStream().listen((tickets) {
      _tickets = tickets;
      notifyListeners();
    });
  }

  Future<void> addTicket(Ticket ticket) async {
    await _firestoreService.addTicket(ticket);
    fetchTickets();
  }

  Future<void> updateTicket(Ticket ticket) async {
    await _firestoreService.updateTicket(ticket);
    fetchTickets();
  }

  Future<void> deleteTicket(String ticketId) async {
    await _firestoreService.deleteTicket(ticketId);
    fetchTickets();
  }
}
