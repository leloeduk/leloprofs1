import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const _cacheKey = 'userLoggedIn';

  @override
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_cacheKey, true); // Cache la connexion
    }
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey); // Supprime le cache
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  User? getCurrentUser() => _auth.currentUser;

  @override
  Future<bool> hasCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_cacheKey) ?? false;
  }
}
