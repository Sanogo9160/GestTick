import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> registerWithEmailAndPassword(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'email': email,
          'role': role,
        });
      }
      return true;
    } catch (e) {
      print('Erreur d\'inscription: $e');
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user != null;
    } catch (e) {
      print('Erreur de connexion: $e');
      return false;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getUserRole() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection('users').doc(user.uid).get();
        final data = doc.data();
        return data?['role'] as String?;
      }
    } catch (e) {
      print('Erreur de récupération du rôle: $e');
    }
    return null;
  }
}
