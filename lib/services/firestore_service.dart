// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gesttick/models/message.dart';
import 'package:gesttick/models/user.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    try {
      final docRef = await _db.collection('tickets').add(ticket.toMap());
      
      // Mettre à jour l'ID du ticket
      await _db.collection('tickets').doc(docRef.id).update({'id': docRef.id});

      // Envoyer des notifications aux formateurs
      await _sendNotificationToTrainers(ticket);

      // Envoyer une notification à l'apprenant
      await _sendNotificationToStudent(ticket.studentId, docRef.id);

    } catch (e) {
      print('Error adding ticket: $e');
    }
  }

  // Mettre à jour un ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await _db.collection('tickets').doc(ticket.id).update(ticket.toMap());

      // Optionnel : Envoyer des notifications après la mise à jour
      await _sendNotificationToStudent(ticket.studentId, ticket.id);

    } catch (e) {
      print('Error updating ticket: $e');
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

  // Méthode pour rechercher les tickets
  Future<List<Ticket>> searchTickets(String query) async {
    try {
      // Requête Firestore pour rechercher les tickets
      final snapshot = await _db.collection('tickets')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

      // Convertir les documents en instances de Ticket
      final tickets = snapshot.docs.map((doc) {
        return Ticket.fromDocument(doc); // Utilisation de la méthode fromDocument
      }).toList();

      return tickets;
    } catch (e) {
      print('Erreur lors de la recherche des tickets: $e');
      return [];
    }
  }

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
      await _db.collection('tickets').doc(ticketId).update({'status': status, 
      'updatedAt': FieldValue.serverTimestamp()
      });
      print('Ticket status updated successfully');
    } catch (e) {
      throw Exception('Error updating ticket status: $e');
    }
  }

  // Marquer un ticket comme résolu
  Future<void> markTicketAsResolved(String ticketId) async {
    try {
      await _db.collection('tickets').doc(ticketId).update({
        'status': 'resolved',
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error marking ticket as resolved: $e');
    }
  }

  // Envoyer des notifications aux formateurs
  Future<void> _sendNotificationToTrainers(Ticket ticket) async {
    try {
      // Recherchez tous les formateurs
      final trainers = await _db.collection('users').where('role', isEqualTo: 'formateur').get();

      for (var doc in trainers.docs) {
        final email = doc.data()['email'];
        final subject = 'Nouveau ticket soumis';
        final message = 'Un nouvel ticket a été soumis par un apprenant. Détails : ${ticket.title}.';

        // Appel à une fonction d'envoi d'e-mail
        await _sendEmail(email, subject, message);
      }
    } catch (e) {
      print('Error sending notifications to trainers: $e');
    }
  }

  // Envoyer une notification à l'apprenant
  Future<void> _sendNotificationToStudent(String studentId, String ticketId) async {
    try {
      // Recherchez l'apprenant
      final studentDoc = await _db.collection('users').doc(studentId).get();
      final email = studentDoc.data()?['email'];
      final subject = 'Votre ticket a été mis à jour';
      final message = 'Votre ticket avec l\'ID $ticketId a été mis à jour.';

      // Appel à une fonction d'envoi d'e-mail
      await _sendEmail(email, subject, message);
    } catch (e) {
      print('Error sending notification to student: $e');
    }
  }

  // Fonction pour envoyer un e-mail
  Future<void> _sendEmail(String email, String subject, String message) async {
    try {
      final response = await http.post(
        Uri.parse('https://www.googleapis.com/auth/gmail.send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'to': email,
          'subject': subject,
          'message': message,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send email');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }

 // Récupérer les tickets pour un apprenant spécifique
Future<Map<String, dynamic>> getTicketsForStudent(String studentId, [DocumentSnapshot? lastDocument]) async {
  Query query = FirebaseFirestore.instance
      .collection('tickets')
      .where('studentId', isEqualTo: studentId);

  if (lastDocument != null) {
    query = query.startAfterDocument(lastDocument);
  }

  final querySnapshot = await query.limit(10).get();

  List<Ticket> tickets = querySnapshot.docs.map((doc) => Ticket.fromDocument(doc)).toList();
  DocumentSnapshot? newLastDocument = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

  return {
    'tickets': tickets,
    'lastDocument': newLastDocument,
  };
}

  // Ajouter une réponse au ticket
  Future<void> addReplyToTicket(String ticketId, String response) async {
    try {
      final ticketRef = _db.collection('tickets').doc(ticketId);
      await ticketRef.update({
        'responses': FieldValue.arrayUnion([response]),
      });
    } catch (e) {
      print('Error adding reply: $e');
      throw e;
    }
  }

  // Ajouter une réponse à un ticket
  Future<void> addResponseToTicket(String ticketId, String response) async {
  try {
    // Ajoute une réponse à un ticket en utilisant une sous-collection
    await _db.collection('tickets').doc(ticketId).collection('responses').add({
      'text': response,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Response added successfully');
  } catch (e) {
    print('Error adding response: $e');
  }
}


// Mettre à jour une réponse existante dans le ticket
  Future<void> updateResponse(String ticketId, int index, String response) async {
    try {
      final ticketRef = _db.collection('tickets').doc(ticketId);
      final ticketDoc = await ticketRef.get();
      final responses = List<String>.from(ticketDoc.get('responses'));

      if (index >= 0 && index < responses.length) {
        responses[index] = response;
        await ticketRef.update({
          'responses': responses,
        });
      }
    } catch (e) {
      print('Error updating response: $e');
      throw e;
    }
  }

  // Supprimer une réponse du ticket
  Future<void> deleteResponseFromTicket(String ticketId, int index) async {
    try {
      final ticketRef = _db.collection('tickets').doc(ticketId);
      final ticketDoc = await ticketRef.get();
      final responses = List<String>.from(ticketDoc.get('responses'));

      if (index >= 0 && index < responses.length) {
        responses.removeAt(index);
        await ticketRef.update({
          'responses': responses,
        });
      }
    } catch (e) {
      print('Error deleting response: $e');
      throw e;
    }
  }

  // Obtenir les réponses pour un ticket
  Stream<List<String>> getResponsesForTicket(String ticketId) {
    return _db.collection('tickets').doc(ticketId).snapshots().map((snapshot) {
      final responses = snapshot.get('responses') as List<dynamic>;
      return responses.map((response) => response as String).toList();
    });
  }


 // Method to get the status of a specific ticket as a stream
  Stream<String> getTicketStatus(String ticketId) {
    // Reference to the specific ticket document
    final ticketRef = _db.collection('tickets').doc(ticketId);

    // Listen to the ticket document and map the status field to the stream
    return ticketRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()?['status'] ?? 'Unknown'; // Provide default value if 'status' is null
      } else {
        return 'No Data'; // Handle the case where the document doesn't exist
      }
    });
  }

  // Méthode pour récupérer les tickets par statut
Stream<List<Ticket>> getTicketsByStatusStream(String status) {
  return _db
      .collection('tickets')
      .where('status', isEqualTo: status)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Ticket.fromDocument(doc)).toList());
}

}