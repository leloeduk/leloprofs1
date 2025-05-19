import '../models/school_model.dart';

abstract class SchoolRepository {
  Future<List<SchoolModel>> getSchools();
  Future<void> createSchool(SchoolModel school);
  Future<void> updateSchool(SchoolModel school);
  Future<void> deleteSchool(String id);
  Future<SchoolModel> getSchoolById(String id);
}
