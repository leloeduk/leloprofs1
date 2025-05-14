import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, super.name, super.email, super.photoUrl});

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}
