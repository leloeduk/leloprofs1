import '../entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  UserModel? getCurrentUser();
  Future<bool> hasCachedUser(); // Vérifie si l'utilisateur est en cache

  // Future<void> updateAccountType(String uid, String accountType); // Ajouté
}
