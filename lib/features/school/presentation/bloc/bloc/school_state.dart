import 'package:equatable/equatable.dart';
import '../../../domain/models/school_model.dart';

abstract class SchoolState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final List<SchoolModel> schools;

  SchoolLoaded(this.schools);

  @override
  List<Object?> get props => [schools];
}

class SchoolIdLoaded extends SchoolState {
  final SchoolModel schools;

  SchoolIdLoaded(this.schools);

  @override
  List<Object?> get props => [schools];
}

class SchoolError extends SchoolState {
  final String message;

  SchoolError(this.message);

  @override
  List<Object?> get props => [message];
}

class SchoolPlanUpdated extends SchoolState {}



// import 'package:equatable/equatable.dart';

// import '../../../../teacher/data/models/teacher_model.dart';
// import '../../../domain/models/school_model.dart';

// abstract class ProfileState extends Equatable {
//   const ProfileState();
// }

// class ProfileInitial extends ProfileState {
//   @override List<Object?> get props => [];
// }

// class ProfileLoading extends ProfileState {
//   @override List<Object?> get props => [];
// }

// class SchoolProfileLoaded extends ProfileState {
//   final SchoolModel school;
//   const SchoolProfileLoaded(this.school);
//   @override List<Object?> get props => [school];
// }

// class TeacherProfileLoaded extends ProfileState {
//   final TeacherModel teacher;
//   const TeacherProfileLoaded(this.teacher);
//   @override List<Object?> get props => [teacher];
// }

// class ProfileOperationSuccess extends ProfileState {
//   final String message;
//   const ProfileOperationSuccess(this.message);
//   @override List<Object?> get props => [message];
// }

// class ProfileError extends ProfileState {
//   final String message;
//   const ProfileError(this.message);
//   @override List<Object?> get props => [message];
// }