import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> resetPassword({required String newPassord}) async {}

  Future<void> sendRecoveryCode({required String email}) async {
    try {
      await _firebase.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _firebase.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  Future<void> signOut() async {
    await _firebase.signOut();
  }

  User? currentUser() {
    final user = _firebase.currentUser;
    return user;
  }
}
