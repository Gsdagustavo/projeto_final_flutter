import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Service class to handle Authentication services using Firebase Auth
class AuthService {
  /// Instance of [FirebaseAuth]
  final _firebase = FirebaseAuth.instance;

  /// Tries to sign in to Firebase Auth with the given [email] and [password]
  ///
  /// Returns the user with the given credentials
  ///
  /// Throws a [FirebaseAuthException] if any error occurs while trying to
  /// sign in
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Tries to create a user using Firebase Auth with the given [email] and
  /// [password]
  ///
  /// Returns the user with the given credentials if the user was created
  /// successfully
  ///
  /// Throws a [FirebaseAuthException] if any error occurs while trying to
  /// create the user
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credentials.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Sends a password recovery email to the given [email]
  ///
  /// Throws a [FirebaseAuthException] if any error occurs while sending the
  /// email
  Future<void> sendPasswordResetEmail({required String email}) async {
    debugPrint('Sending password reset email to $email');

    try {
      await _firebase.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to $email');
    } on FirebaseAuthException {
      debugPrint('Error while trying to send password reset email to $email');
      rethrow;
    }
  }

  /// Signs out of Firebase Auth
  Future<void> signOut() async {
    await _firebase.signOut();
  }

  /// Returns the current logged [User]
  User? currentUser() => _firebase.currentUser;
}
