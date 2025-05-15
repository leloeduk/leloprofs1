abstract class FirestorePaths {
  static String user(String uid) => 'users/$uid';
  static String teacher(String uid) => 'teachers/$uid';
  static String school(String uid) => 'schools/$uid';
  static String get jobs => 'jobs';
  static String jobApplications(String jobId) => 'jobs/$jobId/applications';
}
