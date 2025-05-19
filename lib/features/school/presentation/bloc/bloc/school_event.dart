import 'package:equatable/equatable.dart';
import '../../../domain/models/school_model.dart';

abstract class SchoolEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSchools extends SchoolEvent {}

class CreateSchool extends SchoolEvent {
  final SchoolModel school;

  CreateSchool(this.school);

  @override
  List<Object?> get props => [school];
}

class UpdateSchool extends SchoolEvent {
  final SchoolModel school;

  UpdateSchool(this.school);

  @override
  List<Object?> get props => [school];
}

class DeleteSchool extends SchoolEvent {
  final String id;

  DeleteSchool(this.id);

  @override
  List<Object?> get props => [id];
}

class GetSchoolId extends SchoolEvent {
  final String id;

  GetSchoolId(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateSchoolPlan extends SchoolEvent {
  final String schoolId;
  final String newPlan;

  UpdateSchoolPlan({required this.schoolId, required this.newPlan});

  @override
  List<Object?> get props => [schoolId, newPlan];
}

// part of 'profile_bloc.dart';

// // Événements School
// abstract class ProfileEvent extends Equatable {
//   const ProfileEvent();
// }

// class LoadSchoolProfile extends ProfileEvent {
//   final String uid;
//   const LoadSchoolProfile(this.uid);
//   @override List<Object?> get props => [uid];
// }

// class CreateSchoolProfile extends ProfileEvent {
//   final SchoolModel school;
//   const CreateSchoolProfile(this.school);
//   @override List<Object?> get props => [school];
// }

// class UpdateSchoolProfile extends ProfileEvent {
//   final SchoolModel school;
//   const UpdateSchoolProfile(this.school);
//   @override List<Object?> get props => [school];
// }

// class DeleteSchoolProfile extends ProfileEvent {
//   final String uid;
//   const DeleteSchoolProfile(this.uid);
//   @override List<Object?> get props => [uid];
// }

// // Événements Teacher (similaires)
// class LoadTeacherProfile extends ProfileEvent { ... }
// class CreateTeacherProfile extends ProfileEvent { ... }
// class UpdateTeacherProfile extends ProfileEvent { ... }
// class DeleteTeacherProfile extends ProfileEvent { ... }
