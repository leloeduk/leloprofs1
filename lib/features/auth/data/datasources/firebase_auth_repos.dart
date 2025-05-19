import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_model.dart';

class FirebaseAuthRepos implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuthRepos({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserModel?> signInWithGoogle() async {
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
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        displayName: userCredential.user?.displayName,
      );
      await _firebaseFirestore
          .collection("users")
          .doc(userModel.uid)
          .set(UserModel.fromJson as Map<String, dynamic>);
      return userModel;
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
  UserModel? getCurrentUser() {
    final userModel = _firebaseAuth.currentUser;
    if (userModel == null) {
      return null;
    }
    print("ℹ️ Utilisateur actuel: ${userModel.uid}");
    return UserModel(
      uid: userModel.uid,
      email: userModel.email!,
      displayName: userModel.displayName,
    );
  }

  @override
  Future<bool> hasCachedUser() async {
    final hasUser = _firebaseAuth.currentUser != null;
    print("ℹ️ Utilisateur en cache: $hasUser");
    return hasUser;
  }

  // @override
  // Future<void> updateAccountType(String uid, String accountType) async {
  //   try {
  //     print("🔵 Mise à jour du type de compte pour l'utilisateur $uid");

  //     await FirebaseFirestore.instance.collection('users').doc(uid).set({
  //       'accountType': accountType,
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: true));

  //     print("🟢 Type de compte mis à jour: $accountType");
  //     return; // ✅ Ajout du return ici
  //   } catch (e) {
  //     print("🔴 Erreur lors de la mise à jour du type de compte: $e");
  //     rethrow;
  //   }
  // }
}
