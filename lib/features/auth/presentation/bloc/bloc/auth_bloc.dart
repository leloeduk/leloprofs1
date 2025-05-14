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
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      emit(user != null ? Authenticated(user) : Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      await Future.delayed(const Duration(seconds: 2));
      emit(Unauthenticated());
    }
  }

  Future<void> _onCheckAuthFromCache(
    CheckAuthFromCache event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = authRepository.getCurrentUser();
    emit(user != null ? Authenticated(user) : Unauthenticated());
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}
