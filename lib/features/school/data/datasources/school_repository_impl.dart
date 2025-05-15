import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leloprof/features/school/data/datasources/firebase_school_data_source';

import '../domain/school_repository.dart';
import '../models/school_model.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final FirebaseSchoolDataSource dataSource;

  SchoolRepositoryImpl({required this.dataSource});

  @override
  Future<List<SchoolModel>> getSchools() => dataSource.getSchools();

  @override
  Future<void> createSchool(SchoolModel school) =>
      dataSource.createSchool(school);

  @override
  Future<void> updateSchool(SchoolModel school) =>
      dataSource.updateSchool(school);

  @override
  Future<void> deleteSchool(String id) => dataSource.deleteSchool(id);

  // Nouvelle méthode pour mettre à jour uniquement le plan d'un enseignant
  @override
  Future<void> updateSchoolPlan(String schoolId, String newPlan) async {
    await FirebaseFirestore.instance.collection('schools').doc(schoolId).update(
      {'plan': newPlan},
    );
  }
}
