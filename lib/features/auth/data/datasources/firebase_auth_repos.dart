import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leloprof/features/auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_model.dart';

class FirebaseAuthRepos implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  // Injection des dépendances pour une meilleure testabilité
  FirebaseAuthRepos({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Étape 1: Authentification avec Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Étape 2: Obtention des credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Étape 3: Authentification avec Firebase
      final UserCredential userCred = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final User? firebaseUser = userCred.user;
      if (firebaseUser == null) return null;

      // Étape 4: Création du modèle utilisateur
      return UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Utilisateur sans nom',
        email: firebaseUser.email ?? '',
        role: 'visitor', // Rôle par défaut
        isNewUser: userCred.additionalUserInfo?.isNewUser ?? true,
        createdAt: DateTime.now(),
        isVerified: false,
        isEnabled: true,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    } catch (e) {
      print('Erreur inattendue lors de la connexion Google: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  @override
  UserModel? getCurrentUser() {
    try {
      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      return UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Utilisateur sans nom',
        email: firebaseUser.email ?? '',
        role: 'visitor',
        isNewUser:
            false, // Si l'utilisateur est déjà connecté, ce n'est pas un nouveau
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        isVerified: firebaseUser.emailVerified,
        isEnabled: true,
      );
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  void _handleAuthException(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'account-exists-with-different-credential':
        errorMessage = 'Un compte existe déjà avec des identifiants différents';
        break;
      case 'invalid-credential':
        errorMessage = 'Identifiants invalides';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Cette opération n\'est pas autorisée';
        break;
      case 'user-disabled':
        errorMessage = 'Ce compte a été désactivé';
        break;
      case 'user-not-found':
        errorMessage = 'Aucun compte trouvé';
        break;
      case 'wrong-password':
        errorMessage = 'Mot de passe incorrect';
        break;
      case 'invalid-verification-code':
        errorMessage = 'Code de vérification invalide';
        break;
      case 'network-request-failed':
        errorMessage = 'Erreur réseau';
        break;
      default:
        errorMessage = 'Une erreur d\'authentification est survenue';
    }
    print('Erreur d\'authentification: $errorMessage (${e.code})');
    // Vous pourriez aussi utiliser un système de logging ou afficher une snackbar
  }
}
