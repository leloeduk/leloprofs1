import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leloprof/features/school/domain/repositories/school_repository.dart';

import '../../domain/models/school_model.dart';

class FirebaseSchoolRepos implements SchoolRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<SchoolModel>> getSchools() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("schools").get();
    return snapshot.docs
        .map((doc) => SchoolModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> createSchool(SchoolModel school) async {
    await firestore.collection('schools').doc(school.id).set(school.toMap());
  }

  @override
  Future<void> updateSchool(SchoolModel school) async {
    await firestore.collection('schools').doc(school.id).update(school.toMap());
  }

  @override
  Future<void> deleteSchool(String id) async {
    await firestore.collection('schools').doc(id).delete();
  }

  @override
  Future<SchoolModel> getSchoolById(String id) async {
    final doc = await firestore.collection("schools").doc(id).get();
    if (doc.exists) {
      return SchoolModel.fromJson(doc.data()!);
    }
    return SchoolModel.fromJson(doc.data()!);
  }
}
