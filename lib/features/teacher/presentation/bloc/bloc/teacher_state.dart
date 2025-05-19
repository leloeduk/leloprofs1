import 'package:equatable/equatable.dart';
import '../../../domain/models/teacher_model.dart';

abstract class TeacherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<TeacherModel> teachers;

  TeacherLoaded(this.teachers);

  @override
  List<Object?> get props => [teachers];
}

class TeacherError extends TeacherState {
  final String message;

  TeacherError(this.message);

  @override
  List<Object?> get props => [message];
}
