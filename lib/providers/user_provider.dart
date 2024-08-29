import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/user.dart';
import 'package:gesttick/services/auth_service.dart';
import 'package:gesttick/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  Future<void> loadUser() async {
    // Récupérer l'utilisateur connecté depuis Firebase
    User? firebaseUser = _authService.getCurrentUser();
    if (firebaseUser != null) {
      // Charger les données utilisateur depuis Firestore
      _user = await FirestoreService().getUserById(firebaseUser.uid);
      notifyListeners();
    }
  }

  void logout() {
    _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
