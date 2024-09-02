// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gesttick/models/user.dart';
import 'package:gesttick/models/ticket.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

 // Stream for getting all tickets from Firestore as QuerySnapshot
  Stream<QuerySnapshot<Map<String, dynamic>>> getTickets() {
    return _db.collection('tickets').snapshots();
  }

  // Convert QuerySnapshot to List<Ticket>
  Stream<List<Ticket>> getTicketsStream() {
    return _db.collection('tickets').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Ticket.fromDocument(doc)).toList());
  }
  // Ajouter un ticket
  Future<void> addTicket(Ticket ticket) async {
    try{
      await _db.collection('tickets').add(ticket.toMap());
    }catch (e) {
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
