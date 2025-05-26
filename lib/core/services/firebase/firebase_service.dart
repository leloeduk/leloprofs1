import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> updateUserRole(String uid, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': role,
    });
  }
}
