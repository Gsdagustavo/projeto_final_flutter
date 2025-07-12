import 'package:firebase_auth/firebase_auth.dart';

class Auth {
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
    if (email.isEmpty || !email.contains('@')) {
      return null;
    }

    if (password.isEmpty || password.length <= 3) {
      return null;
    }

    try {
      await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
