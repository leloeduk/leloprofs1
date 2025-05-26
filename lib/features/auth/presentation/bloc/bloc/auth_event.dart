import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class UpdateUserRoleLocally extends AuthEvent {
  final String role;
  const UpdateUserRoleLocally(this.role);
}

class MarkUserAsRegistered extends AuthEvent {
  const MarkUserAsRegistered();
}
