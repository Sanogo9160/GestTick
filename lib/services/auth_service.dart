import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mise à jour de la méthode d'inscription pour inclure le statut par défaut

  
  Future<bool> registerWithEmailAndPassword(
    String email, 
    String password, 
    String role, 
    String fullName, 
    String phone
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'email': email,
          'role': role,
          'fullName': fullName,    
          'phone': phone,
          'status': 'pending',  // Statut par défaut
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
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    User? user = result.user;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection('users').doc(user.uid).get();
      final data = doc.data();
      // Vérifier si l'utilisateur est approuvé
      if (data?['status'] == 'approved') {
        return true;
      } else {
        await _auth.signOut();
        print('Compte non approuvé');
      }
    }
    return false;
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

  // Méthode pour créer un compte administrateur par défaut si aucun n'existe
  Future<void> createDefaultAdmin() async {
    const adminEmail = 'admin@gmail.com';
    const adminPassword = 'admin@password';
    const adminRole = 'admin';
    const adminFullName = 'Default Admin';
    const adminPhone = '90900987';

    try {
      // Vérifier si l'utilisateur admin existe
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('users')
        .where('email', isEqualTo: adminEmail)
        .get();
      
      if (snapshot.docs.isEmpty) {
        // Créer l'utilisateur admin
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        User? user = result.user;

        if (user != null) {
          await _db.collection('users').doc(user.uid).set({
            'email': adminEmail,
            'role': adminRole,
            'fullName': adminFullName,
            'phone': adminPhone,
            'status': 'approved',  // L'admin est approuvé par défaut
          });
        }
      } else {
        print('Admin user already exists.');
      }
    } catch (e) {
      print('Erreur lors de la création de l\'admin : $e');
    }
  }

  // Méthode pour que l'administrateur approuve un utilisateur
  Future<bool> approveUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).update({
        'status': 'approved',
      });
      return true;
    } catch (e) {
      print('Erreur lors de l\'approbation de l\'utilisateur: $e');
      return false;
    }
  }
}
