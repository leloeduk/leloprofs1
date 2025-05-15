import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class CheckAuthFromCache extends AuthEvent {}

class UpdateAccountType extends AuthEvent {
  final String accountType;

  UpdateAccountType(this.accountType);

  @override
  List<Object> get props => [accountType]; // <-- ici c'est List<Object>, pas List<Object?>
}
