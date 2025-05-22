import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_model.dart';

class FirebaseAuthRepos implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepos({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      print("🔵 1. Début de signInWithGoogle()");

      // Étape 1: Connexion avec Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("🔴 Annulation de la connexion par l'utilisateur");
        return null;
      }

      // Étape 2: Authentification Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Étape 3: Création des credentials Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Étape 4: Connexion Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception("Firebase User is null after sign in");
      }

      // Étape 5: Création du modèle utilisateur
      final user = userCredential.user!;
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? 'no-email-provided',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );

      // // Étape 6: Sauvegarde dans Firestore
      // await _firestore
      //     .collection('users')
      //     .doc(user.uid)
      //     .set(
      //       userModel.toMap(),
      //       SetOptions(merge: true), // Fusionne si le document existe déjà
      //     );

      return userModel;
    } catch (e, stackTrace) {
      print("🔴 Erreur lors de la connexion Google: $e");
      print("🔴 StackTrace: $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);
    } catch (e) {
      print("🔴 Erreur lors de la déconnexion: $e");
      rethrow;
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      email: user.email ?? 'no-email',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<bool> hasCachedUser() async {
    return _firebaseAuth.currentUser != null;
  }
}
