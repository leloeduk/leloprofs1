import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;

  AuthBloc(this._authRepo, sl) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
    on<CheckAuthFromCache>(_onCheckAuthFromCache);
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signInWithGoogle();
      emit(user != null ? Authenticated(user) : Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepo.signOut();
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuthFromCache(
    CheckAuthFromCache event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final hasCache = await _authRepo.hasCachedUser();
    if (hasCache) {
      final user = _authRepo.getCurrentUser();
      emit(user != null ? Authenticated(user) : Unauthenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}
