import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leloprof/features/school/domain/repositories/school_repository.dart';

import '../../domain/models/school_model.dart';

class FirebaseSchoolRepos implements SchoolRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<SchoolModel>> getSchools() async {
    final current = FirebaseAuth.instance.currentUser!;
    final snapshot =
        await firestore
            .collection('schools')
            .where('Uid', isEqualTo: current.uid)
            .get();
    return snapshot.docs
        .map((doc) => SchoolModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> createSchool(SchoolModel school) async {
    await firestore.collection('schools').add(school.toMap());
  }

  @override
  Future<void> updateSchool(SchoolModel school) async {
    await firestore
        .collection('schools')
        .doc(school.uid)
        .update(school.toMap());
  }

  @override
  Future<void> deleteSchool(String id) async {
    await firestore.collection('schools').doc(id).delete();
  }

  @override
  Future<SchoolModel> getSchoolById(String id) async {
    final doc = await firestore.collection("schools").doc(id).get();
    if (doc.exists) {
      return SchoolModel.fromJson(doc.data()!, doc.id);
    }
    return SchoolModel.fromJson(doc.data()!, doc.id);
  }
}
