import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
  Future<bool> hasCachedUser(); // Vérifie si l'utilisateur est en cache

  Future<void> updateAccountType(String uid, String accountType); // Ajouté
  Future<User?> getUserById(String uid);
}
