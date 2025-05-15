import 'package:equatable/equatable.dart';
import '../../../data/models/school_model.dart';

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

class UpdateSchoolPlan extends SchoolEvent {
  final String schoolId;
  final String newPlan;

  UpdateSchoolPlan({required this.schoolId, required this.newPlan});

  @override
  List<Object?> get props => [schoolId, newPlan];
}
