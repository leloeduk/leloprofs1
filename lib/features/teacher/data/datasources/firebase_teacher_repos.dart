import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../../domain/models/teacher_model.dart';

class FirebaseTeacherRepos implements TeacherRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get _teachersRef => firestore.collection('teachers');

  @override
  Future<List<TeacherModel>> fetchAllTeachers() async {
    // final current = FirebaseAuth.instance.currentUser!;
    final snapshot = await _teachersRef.get();
    return snapshot.docs
        .map((doc) => TeacherModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createTeacher(TeacherModel teacher) async {
    await _teachersRef.doc(teacher.id).set(teacher.toJson());
  }

  @override
  Future<void> updateTeacher(TeacherModel teacher) async {
    await _teachersRef.doc(teacher.id).update(teacher.toJson());
  }

  @override
  Future<void> deleteTeacher(String id) async {
    await _teachersRef.doc(id).delete();
  }

  @override
  Future<TeacherModel?> getTeacherById(String id) async {
    final doc = await _teachersRef.doc(id).get();
    if (doc.exists) {
      return TeacherModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
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
  }) async {
    // Récupérer tous les enseignants
    List<TeacherModel> teachers = await fetchAllTeachers();

    // Appliquer les filtres
    if (name != null) {
      teachers =
          teachers
              .where(
                (teacher) =>
                    teacher.firstName.toLowerCase().contains(
                      name.toLowerCase(),
                    ) ||
                    teacher.lastName.toLowerCase().contains(name.toLowerCase()),
              )
              .toList();
    }

    if (department != null) {
      teachers =
          teachers
              .where(
                (teacher) =>
                    teacher.department.toLowerCase() ==
                    department.toLowerCase(),
              )
              .toList();
    }

    if (country != null) {
      teachers =
          teachers
              .where(
                (teacher) =>
                    teacher.country?.toLowerCase() == country.toLowerCase(),
              )
              .toList();
    }

    if (district != null) {
      teachers =
          teachers
              .where(
                (teacher) =>
                    teacher.district?.toLowerCase() == district.toLowerCase(),
              )
              .toList();
    }

    if (subjects != null && subjects.isNotEmpty) {
      teachers =
          teachers
              .where(
                (teacher) => subjects.any(
                  (subject) => teacher.subjects.contains(subject),
                ),
              )
              .toList();
    }

    if (languages != null && languages.isNotEmpty) {
      teachers =
          teachers
              .where(
                (teacher) => languages.any(
                  (language) => teacher.languages.contains(language),
                ),
              )
              .toList();
    }

    if (isAvailable != null) {
      teachers =
          teachers
              .where((teacher) => teacher.isAvailable == isAvailable)
              .toList();
    }

    if (isCivilServant != null) {
      teachers =
          teachers
              .where((teacher) => teacher.isCivilServant == isCivilServant)
              .toList();
    }

    if (isInspector != null) {
      teachers =
          teachers
              .where((teacher) => teacher.isInspector == isInspector)
              .toList();
    }

    if (yearsOfExperience != null) {
      teachers =
          teachers
              .where(
                (teacher) => teacher.yearsOfExperience >= yearsOfExperience,
              )
              .toList();
    }

    if (educationCycles != null && educationCycles.isNotEmpty) {
      teachers =
          teachers
              .where(
                (teacher) => educationCycles.any(
                  (cycle) => teacher.educationCycles.contains(cycle),
                ),
              )
              .toList();
    }

    if (diplomas != null && diplomas.isNotEmpty) {
      teachers =
          teachers
              .where(
                (teacher) => diplomas.any(
                  (diploma) => teacher.diplomas.contains(diploma),
                ),
              )
              .toList();
    }

    return teachers;
  }

  // Nouvelle méthode pour gérer le plan d’un enseignant
  //   @override
  //   Future<void> updateTeacherPlan(String teacherId, String newPlan) async {
  //     await _teachersRef.doc(teacherId).update({'plan': newPlan});
  //   }
}
