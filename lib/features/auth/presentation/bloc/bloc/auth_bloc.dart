import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:leloprof/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../core/services/sharedpreferences/shared_prefs.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInWithGoogleRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<UpdateUserRoleLocally>(_onUpdateUserRoleLocally);
    on<MarkUserAsRegistered>(_onMarkUserAsRegistered);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = SharedPrefs.getUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onGoogleSignInRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        await SharedPrefs.saveUser(user);
        emit(Authenticated(user));
      } else {
        emit(const AuthError("Google Sign-In failed."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
    await SharedPrefs.clear();
    emit(Unauthenticated());
  }

  Future<void> _onUpdateUserRoleLocally(
    UpdateUserRoleLocally event,
    Emitter<AuthState> emit,
  ) async {
    if (state is Authenticated) {
      final currentState = state as Authenticated;
      final updatedUser = currentState.user.copyWith(role: event.role);
      await SharedPrefs.saveUser(updatedUser); // <-- AJOUT IMPORTANT
      emit(Authenticated(updatedUser));
    }
  }

  Future<void> _onMarkUserAsRegistered(
    MarkUserAsRegistered event,
    Emitter<AuthState> emit,
  ) async {
    if (state is Authenticated) {
      final currentState = state as Authenticated;
      final updatedUser = currentState.user.copyWith(isNewUser: false);
      await SharedPrefs.saveUser(updatedUser); // <-- AJOUT IMPORTANT
      emit(Authenticated(updatedUser));
    }
  }
}
