import 'package:equatable/equatable.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';

class TeacherApplicationData {
  final String teacherId;
  final String? firstName;
  final String lastName;
  final String profileImageUrl;
  final String department;
  final List<String> subjects;
  final double? rating;

  const TeacherApplicationData({
    required this.teacherId,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.department,
    required this.subjects,
    required this.rating,
  });

  factory TeacherApplicationData.fromModel(TeacherModel model) {
    return TeacherApplicationData(
      teacherId: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      profileImageUrl: model.profileImageUrl ?? '',
      department: model.department,
      subjects: model.subjects,
      rating: model.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'department': department,
      'subjects': subjects,
      'rating': rating,
    };
  }
}
