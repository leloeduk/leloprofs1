import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leloprof/features/school/domain/repositories/school_repository.dart';

import '../../domain/models/school_model.dart';

class FirebaseSchoolRepos implements SchoolRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<SchoolModel>> getSchools() async {
    try {
      final snapshot = await firestore.collection("schools").get();
      return snapshot.docs
          .map((doc) => SchoolModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des écoles : $e');
    }
  }

  @override
  Future<void> createSchool(SchoolModel school) async {
    try {
      await firestore.collection('schools').doc(school.id).set(school.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'école : $e');
    }
  }

  @override
  Future<void> updateSchool(SchoolModel school) async {
    try {
      await firestore
          .collection('schools')
          .doc(school.id)
          .update(school.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'école : $e');
    }
  }

  @override
  Future<void> deleteSchool(String id) async {
    try {
      await firestore.collection('schools').doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'école : $e');
    }
  }

  @override
  Future<SchoolModel> getSchoolById(String id) async {
    try {
      final doc = await firestore.collection("schools").doc(id).get();
      if (doc.exists && doc.data() != null) {
        return SchoolModel.fromJson(doc.data()!);
      } else {
        throw Exception("École avec l'identifiant $id introuvable");
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'école : $e');
    }
  }
}
