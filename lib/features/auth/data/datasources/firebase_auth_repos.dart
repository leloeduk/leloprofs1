import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leloprof/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/user_model.dart';

class FirebaseAuthRepos implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _firebaseAuth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      role: 'visitor',
    );
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      role: 'visitor',
    );
  }
}
