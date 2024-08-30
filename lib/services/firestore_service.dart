// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gesttick/models/user.dart';
import 'package:gesttick/models/ticket.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter un ticket
  Future<void> addTicket(Ticket ticket) async {
    try {
      await _db.collection('tickets').doc(ticket.id).set(ticket.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Mettre à jour un ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await _db.collection('tickets').doc(ticket.id).update(ticket.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Récupérer les tickets
  Stream<List<Ticket>> getTickets() {
    return _db.collection('tickets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromMap(doc.data())).toList();
    });
  }

  // Supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await _db.collection('tickets').doc(ticketId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

//
  getUserById(String uid) {}

}
