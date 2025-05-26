import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leloprof/features/school/domain/repositories/school_repository.dart';

import '../../domain/models/school_model.dart';

class FirebaseSchoolRepos implements SchoolRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<SchoolModel>> getSchools() async {
    final current = FirebaseAuth.instance.currentUser;
    if (current == null) throw Exception('Non authentifié');

    final snapshot =
        await firestore
            .collection('schools')
            // .where('uid', isEqualTo: current.uid) // Notez la minuscule
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Assurez-vous d'inclure l'ID du document
      return SchoolModel.fromJson(data);
    }).toList();
  }

  @override
  Future<void> createSchool(SchoolModel school) async {
    await firestore.collection('schools').add(school.toMap());
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
