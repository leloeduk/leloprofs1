import 'package:equatable/equatable.dart';
import '../../../data/models/school_model.dart';

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

class SchoolError extends SchoolState {
  final String message;

  SchoolError(this.message);

  @override
  List<Object?> get props => [message];
}

class SchoolPlanUpdated extends SchoolState {}
