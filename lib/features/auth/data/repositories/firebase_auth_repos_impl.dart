import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User?> signInWithGoogle() async {
    try {
      print("🔵 1. Début de signInWithGoogle()");

      print("🟠 2. Lancement de GoogleSignIn().signIn()...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("🔴 3. L'utilisateur a annulé la connexion Google");
        return null;
      }
      print("🟢 3. Google Sign-In réussi, email: ${googleUser.email}");

      print("🟠 4. Obtention des credentials Google...");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print(
        "🟢 5. Credentials obtenus (token: ${googleAuth.idToken != null ? 'OUI' : 'NON'})",
      );

      print("🟠 6. Création de AuthCredential...");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("🟠 7. Tentative de connexion Firebase...");
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      print("🟢 8. Firebase Auth réussi! UID: ${userCredential.user?.uid}");
      return userCredential.user;
    } catch (e, stackTrace) {
      print("🔴 ERREUR CRITIQUE dans signInWithGoogle():");
      print("🔴 Message: $e");
      print("🔴 StackTrace: $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    print("🔵 Début de signOut()");
    try {
      print("🟠 Déconnexion de GoogleSignIn...");
      await _googleSignIn.signOut();

      print("🟠 Déconnexion de FirebaseAuth...");
      await _firebaseAuth.signOut();

      print("🟢 Déconnexion réussie");
    } catch (e) {
      print("🔴 Erreur lors de signOut(): $e");
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    print("ℹ️ Utilisateur actuel: ${user?.uid ?? 'null'}");
    return user;
  }

  @override
  Future<bool> hasCachedUser() async {
    final hasUser = _firebaseAuth.currentUser != null;
    print("ℹ️ Utilisateur en cache: $hasUser");
    return hasUser;
  }

  @override
  Future<void> updateAccountType(String uid, String accountType) async {
    try {
      print("🔵 Mise à jour du type de compte pour l'utilisateur $uid");

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'accountType': accountType,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("🟢 Type de compte mis à jour: $accountType");
      return; // ✅ Ajout du return ici
    } catch (e) {
      print("🔴 Erreur lors de la mise à jour du type de compte: $e");
      rethrow;
    }
  }

  @override
  Future<User?> getUserById(String uid) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        print("ℹ️ Récupération de l'utilisateur courant par ID");
        return currentUser;
      } else {
        print("⚠️ Aucun utilisateur courant ne correspond à l'UID");
        return null;
      }
    } catch (e) {
      print("🔴 Erreur dans getUserById: $e");
      rethrow;
    }
  }
}
