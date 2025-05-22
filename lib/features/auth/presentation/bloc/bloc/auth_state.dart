import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel userModel;
  Authenticated(this.userModel);
  @override
  List<Object?> get props => [userModel];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AccountTypeSelectionRequired extends AuthState {
  final UserModel userModel;

  AccountTypeSelectionRequired(this.userModel);

  @override
  List<Object?> get props => [userModel];
}
