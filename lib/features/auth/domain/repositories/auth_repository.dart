import '../entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  UserModel? getCurrentUser();
}
