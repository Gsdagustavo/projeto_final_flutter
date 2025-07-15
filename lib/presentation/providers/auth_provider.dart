import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  late User? _loggedUser;
  String? _errorMsg;

  UserProvider() {
    _init();
  }

  void _init() async {
    _loggedUser = await _authService.currentUser();
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _loggedUser = null;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _errorMsg = e.message;
      notifyListeners();
      return;
    }

    _errorMsg = null;
    notifyListeners();
  }

  Future<void> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _loggedUser = await _authService.signinWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _errorMsg = e.message;
      notifyListeners();
      return;
    }

    _errorMsg = null;
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _loggedUser = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.message;
      debugPrint(_errorMsg);
      notifyListeners();
      return;
    }

    _errorMsg = null;
    notifyListeners();
  }

  User? get loggedUser => _loggedUser;

  bool get hasError => _errorMsg != null;

  String get errorMsg => _errorMsg!;
}
