abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
  Future<bool> hasCachedUser(); // Vérifie si l'utilisateur est en cache
}
