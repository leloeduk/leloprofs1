import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  const UserModel({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
  }) : super(
         uid: uid,
         email: email,
         displayName: displayName,
         photoUrl: photoUrl,
         phoneNumber: phoneNumber,
       );

  // Convertit Firebase User → UserModel
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  // Convertit UserModel → Map (pour Firestore)
  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
    };
  }
}
