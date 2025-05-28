import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        .map((doc) => TeacherModel.fromMap(doc.data() as Map<String, dynamic>))
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
      return TeacherModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Nouvelle méthode pour gérer le plan d’un enseignant
  //   @override
  //   Future<void> updateTeacherPlan(String teacherId, String newPlan) async {
  //     await _teachersRef.doc(teacherId).update({'plan': newPlan});
  //   }
}
