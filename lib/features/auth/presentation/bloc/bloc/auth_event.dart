import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class CheckAuthFromCache extends AuthEvent {}

class UpdateAccountType extends AuthEvent {
  final String uid; // <-- Ajouté
  final String accountType;

  UpdateAccountType({required this.uid, required this.accountType});

  @override
  List<Object> get props => [uid, accountType];
}
