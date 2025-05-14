import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<bool> hasCachedUser() async {
    return _firebaseAuth.currentUser != null;
  }
}
