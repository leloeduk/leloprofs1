import 'package:equatable/equatable.dart';

abstract class TeacherApplicationState extends Equatable {
  const TeacherApplicationState();

  @override
  List<Object?> get props => [];
}

class TeacherApplicationInitial extends TeacherApplicationState {}

class TeacherApplicationLoading extends TeacherApplicationState {}

class TeacherApplicationSuccess extends TeacherApplicationState {}

class TeacherApplicationError extends TeacherApplicationState {
  final String message;

  const TeacherApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}
