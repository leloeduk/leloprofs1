import 'package:equatable/equatable.dart';
import '../../../domain/models/teacher_model.dart';

abstract class TeacherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeachers extends TeacherEvent {}

class CreateTeacher extends TeacherEvent {
  final TeacherModel teacher;

  CreateTeacher(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

class UpdateTeacher extends TeacherEvent {
  final TeacherModel teacher;

  UpdateTeacher(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

class DeleteTeacher extends TeacherEvent {
  final String id;

  DeleteTeacher(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateTeacherPlan extends TeacherEvent {
  final String teacherId;
  final String newPlan;

  UpdateTeacherPlan({required this.teacherId, required this.newPlan});

  @override
  List<Object?> get props => [teacherId, newPlan];
}
