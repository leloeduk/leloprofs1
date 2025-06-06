import '../models/teacher_model.dart';

abstract class TeacherRepository {
  Future<List<TeacherModel>> fetchAllTeachers();
  Future<void> createTeacher(TeacherModel teacher);
  Future<void> updateTeacher(TeacherModel teacher);
  Future<void> deleteTeacher(String uid);
  Future<TeacherModel?> getTeacherById(String uid);
  Future<List<TeacherModel>> searchTeachers({
    String? name,
    String? department,
    String? country,
    String? district,
    List<String>? subjects,
    List<String>? languages,
    bool? isAvailable,
    bool? isCivilServant,
    bool? isInspector,
    int? yearsOfExperience,
    List<String>? educationCycles,
    List<String>? diplomas,
  });

  // Nouvelle méthode pour mettre à jour uniquement le plan d'un enseignant
  // Future<void> updateTeacherPlan(String teacherId, String newPlan);
}
