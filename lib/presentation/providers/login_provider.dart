import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

/// A [ChangeNotifier] responsible for managing and the app's login system
///
/// It uses [AuthService] for handling auth services, such as signing in
/// creating a new user, signing out, etc.
class LoginProvider with ChangeNotifier {
  /// Instance of [AuthService]
  final AuthService _authService = AuthService();

  /// The current logged [User]
  late User? _loggedUser;

  /// The error message (obtained via exception.message on try-catch structures)
  String? _errorMsg;

  /// Calls the [_init] method to initialize the provider's internal state
  LoginProvider() {
    _init();
  }

  /// Initializes the provider state, assigning [currentUser] to the current
  /// logged user in [FirebaseAuth]
  void _init() {
    _loggedUser = _authService.currentUser();
    notifyListeners();
  }

  /// Tries to sign out from [FirebaseAuth]
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

  /// Tries to sign in with [email] and [password]
  ///
  /// If any exception is caught during this process, the error message
  /// of the exception is assigned to [_errorMsg]
  ///
  /// Otherwise, [_errorMsg] is set to [Null]
  Future<void> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _loggedUser = await _authService.signinWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Current user: $_loggedUser');
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _errorMsg = e.message;
      notifyListeners();
      return;
    }

    _errorMsg = null;
    notifyListeners();
  }

  /// Tries to create an user with the given [email] and [password]
  ///
  /// If any exception is caught during this process, the error message
  /// of the exception is assigned to [_errorMsg]
  ///
  /// Otherwise, [_errorMsg] is set to [Null]
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _loggedUser = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Current user: $_loggedUser');
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.message;
      debugPrint(_errorMsg);
      notifyListeners();
      return;
    }

    _errorMsg = null;
    notifyListeners();
  }

  /// Sends a password reset email to the given [email]
  ///
  /// If any exception is caught during this process, the error message
  /// of the exception is assigned to [_errorMsg]
  ///
  /// Otherwise, [_errorMsg] is set to [Null]
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.message;
      debugPrint(_errorMsg);
      notifyListeners();
      return;
    }

    _errorMsg = null;
    notifyListeners();
  }

  /// Returns the current [loggedUser]
  User? get loggedUser => _loggedUser;

  /// Returns whether there is an [error message] or not
  bool get hasError => _errorMsg != null;

  /// Returns the error message
  String get errorMsg => _errorMsg!;
}
