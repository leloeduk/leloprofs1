import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacher_repository.dart';
import '../models/teacher_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final FirebaseFirestore firestore;

  TeacherRepositoryImpl({required this.firestore});

  CollectionReference get _teachersRef => firestore.collection('teachers');

  @override
  Future<List<TeacherModel>> fetchAllTeachers() async {
    final snapshot = await _teachersRef.get();
    return snapshot.docs
        .map(
          (doc) =>
              TeacherModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  @override
  Future<void> createTeacher(TeacherModel teacher) async {
    await _teachersRef.doc(teacher.id).set(teacher.toMap());
  }

  @override
  Future<void> updateTeacher(TeacherModel teacher) async {
    await _teachersRef.doc(teacher.id).update(teacher.toMap());
  }

  @override
  Future<void> deleteTeacher(String id) async {
    await _teachersRef.doc(id).delete();
  }

  @override
  Future<TeacherModel?> getTeacherById(String id) async {
    final doc = await _teachersRef.doc(id).get();
    if (doc.exists) {
      return TeacherModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Nouvelle méthode pour gérer le plan d’un enseignant
  @override
  Future<void> updateTeacherPlan(String teacherId, String newPlan) async {
    await _teachersRef.doc(teacherId).update({'plan': newPlan});
  }
}
