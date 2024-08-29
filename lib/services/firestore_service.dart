// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gesttick/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Méthode pour obtenir tous les tickets
  Future<List<Map<String, dynamic>>> getTickets() async {
    try {
      QuerySnapshot snapshot = await _db.collection('tickets').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Erreur lors de la récupération des tickets: $e');
      return [];
    }
  }

  // Méthode pour ajouter un nouveau ticket
  Future<void> addTicket(Map<String, dynamic> ticketData) async {
    try {
      await _db.collection('tickets').add(ticketData);
    } catch (e) {
      print('Erreur lors de l\'ajout du ticket: $e');
    }
  }

  // Méthode pour mettre à jour un ticket existant
  Future<void> updateTicket(String ticketId, Map<String, dynamic> ticketData) async {
    try {
      await _db.collection('tickets').doc(ticketId).update(ticketData);
    } catch (e) {
      print('Erreur lors de la mise à jour du ticket: $e');
    }
  }

  // Méthode pour supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await _db.collection('tickets').doc(ticketId).delete();
    } catch (e) {
      print('Erreur lors de la suppression du ticket: $e');
    }
  }

  // Méthode pour obtenir les détails d'un ticket spécifique
  Future<Map<String, dynamic>?> getTicketDetails(String ticketId) async {
    try {
      DocumentSnapshot doc = await _db.collection('tickets').doc(ticketId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Erreur lors de la récupération des détails du ticket: $e');
      return null;
    }
  }

 // Méthode pour obtenir les données d'un utilisateur par ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        print('Utilisateur non trouvé');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

}
