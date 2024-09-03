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
      DocumentReference ticketRef = _db.collection('tickets').doc(ticketId);
      await ticketRef.delete();
      print('Ticket with ID $ticketId deleted successfully');
    } catch (e) {
      print('Error deleting ticket with ID $ticketId: $e');
      throw e; 
    }
  }

//
  getUserById(String uid) {}

  // Method to fetch tickets for a specific trainer by trainer ID
  Stream<List<Ticket>> getTicketsForTrainer(String trainerId) {
    return _db
        .collection('tickets')
        .where('trainerId', isEqualTo: trainerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Ticket.fromDocument(doc)).toList());
  }

 // Mettre à jour le statut du ticket
  
  Future<void> updateTicketStatus(String ticketId, String status) async {
    try {
      await _db.collection('tickets').doc(ticketId).update({'status': status, 'updatedAt': DateTime.now()});
    } catch (e) {
      print('Error updating ticket status: $e');
    }
  }


   // Ajouter une réponse à un ticket
  Future<void> addResponseToTicket(String ticketId, String response, String trainerId) async {
    try {
      await _db.collection('tickets').doc(ticketId).update({
        'response': response,
        'trainerId': trainerId,
        'status': 'in_progress',
        'updatedAt': DateTime.now()
      });
    } catch (e) {
      print('Error adding response to ticket: $e');
    }
  }

  // Marquer un ticket comme résolu
  Future<void> markTicketAsResolved(String ticketId) async {
    try {
      await _db.collection('tickets').doc(ticketId).update({
        'status': 'resolved',
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error marking ticket as resolved: $e');
    }
  }

  

}
