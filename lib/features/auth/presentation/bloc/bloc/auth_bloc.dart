import 'package:bloc/bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
    on<CheckAuthFromCache>(_onCheckAuthFromCache);
    on<UpdateAccountType>(_onUpdateAccountType);
  }

  Future<void> _onUpdateAccountType(
    UpdateAccountType event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = authRepository.getCurrentUser();
      if (user == null) {
        emit(Unauthenticated());
        return;
      }

      // Mise à jour du type de compte
      await authRepository.updateAccountType(user.uid, event.accountType);

      // Récupère les infos utilisateur mises à jour
      final updatedUser = await authRepository.getUserById(user.uid);

      if (updatedUser != null) {
        emit(Authenticated(updatedUser)); // utilisateur mis à jour
      } else {
        emit(
          AuthError("Impossible de récupérer l'utilisateur après mise à jour."),
        );
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError("Erreur mise à jour type compte: ${e.toString()}"));
      emit(Unauthenticated());
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("🔵 BLoC: Début de _onGoogleSignIn → Emission de AuthLoading");
    emit(AuthLoading());

    try {
      print("🟠 BLoC: Appel à authRepository.signInWithGoogle()...");
      final user = await authRepository.signInWithGoogle();

      if (user != null) {
        print("🟢 BLoC: Utilisateur connecté → Emission de Authenticated");
        emit(Authenticated(user));
      } else {
        print(
          "🟡 BLoC: Utilisateur null (annulé?) → Emission de Unauthenticated",
        );
        emit(Unauthenticated());
      }
    } catch (e) {
      print("🔴 BLoC: Erreur → Emission de AuthError");
      emit(AuthError("Erreur Google Sign-In: ${e.toString()}"));

      print("🟡 BLoC: Après délai → Emission de Unauthenticated");
      emit(Unauthenticated());
    }
  }

  Future<void> _onCheckAuthFromCache(
    CheckAuthFromCache event,
    Emitter<AuthState> emit,
  ) async {
    print("🔵 BLoC: Vérification de l'utilisateur en cache");
    emit(AuthLoading());
    final user = authRepository.getCurrentUser();
    print("ℹ️ BLoC: Utilisateur en cache: ${user?.uid ?? 'null'}");
    emit(user != null ? Authenticated(user) : Unauthenticated());
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("🔵 BLoC: Début de la déconnexion");
    await authRepository.signOut();
    print("🟢 BLoC: Déconnexion réussie → Emission de Unauthenticated");
    emit(Unauthenticated());
  }
}
