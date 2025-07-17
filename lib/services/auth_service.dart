import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _firebase = FirebaseAuth.instance;

  Future<User?> signinWithEmailAndPassword({
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

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final User? user;
    try {
      final credentials = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credentials.user;
    } on FirebaseAuthException {
      rethrow;
    }

    return user;
  }

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

  Future<void> signOut() async {
    await _firebase.signOut();
  }

  User? currentUser() {
    return _firebase.currentUser;
  }
}
