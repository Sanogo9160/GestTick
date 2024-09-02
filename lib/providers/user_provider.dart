import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String? _role;

  // Ajout de la propriété userId
  String? get userId => _user?.uid;
  User? get user => _user;
  String? get role => _role;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (_user != null) {
      try {
        DocumentSnapshot doc = await _db.collection('users').doc(_user!.uid).get();
        _role = doc['role'] as String?;
      } catch (e) {
        print('Erreur lors de la récupération du rôle : $e');
        _role = null;
      }
    } else {
      _role = null;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _role = null;
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    }
  }
}
