import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/school_model.dart';

class FirebaseSchoolDataSource {
  final FirebaseFirestore firestore;

  FirebaseSchoolDataSource({required this.firestore});

  Future<List<SchoolModel>> getSchools() async {
    final snapshot = await firestore.collection('schools').get();
    return snapshot.docs
        .map((doc) => SchoolModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> createSchool(SchoolModel school) async {
    await firestore.collection('schools').add(school.toMap());
  }

  Future<void> updateSchool(SchoolModel school) async {
    await firestore.collection('schools').doc(school.id).update(school.toMap());
  }

  Future<void> deleteSchool(String id) async {
    await firestore.collection('schools').doc(id).delete();
  }

  Future<void> updateSchoolPlan(String schoolId, String newPlan) async {
    await firestore.collection('schools').doc(schoolId).update({
      'plan': newPlan,
    });
  }
}
