import 'package:equatable/equatable.dart';
import 'package:leloprof/features/teacherapp/models/teacher_application_model.dart';

abstract class TeacherApplicationEvent extends Equatable {
  const TeacherApplicationEvent();

  @override
  List<Object?> get props => [];
}

class ApplyToJobOffer extends TeacherApplicationEvent {
  final String jobId;
  final TeacherApplicationData teacherData;

  const ApplyToJobOffer({required this.jobId, required this.teacherData});

  @override
  List<Object?> get props => [jobId, teacherData];
}
