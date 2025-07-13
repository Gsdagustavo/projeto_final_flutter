import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebase = FirebaseAuth.instance;

  static const String _authTokenKey = 'auth_token';

  Future<User?> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // final storage = FlutterSecureStorage();

    try {
      final userCredential = await _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // storage.write(key: _authTokenKey, value: userCredential.credential)
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

    if (email.isEmpty || !email.contains('@')) {
      return null;
    }

    if (password.isEmpty || password.length <= 3) {
      return null;
    }

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

  Future<void> signOut() async {
    await _firebase.signOut();
  }

  Future<User?> checkUserAvailable() async {
    return _firebase.currentUser;
  }
}
