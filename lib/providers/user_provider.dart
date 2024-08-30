import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/user.dart';
import 'package:gesttick/services/auth_service.dart';
import 'package:gesttick/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? get user => _user;

  Future<void> loadUser() async {
    User? firebaseUser = _authService.getCurrentUser();
    if (firebaseUser != null) {
      _user = await _firestoreService.getUserById(firebaseUser.uid);
      notifyListeners();
    }
  }

  void logout() {
    _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
