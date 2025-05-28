// lib/core/helpers/permission_helper.dart

import '../../../auth/domain/entities/user_model.dart';
import '../../domain/models/teacher_model.dart';

class PermissionHelper {
  static bool canEditTeacherProfile({
    required UserModel user,
    required TeacherModel teacher,
  }) {
    return user.role == 'enseignant' && user.id == teacher.id;
  }
}
