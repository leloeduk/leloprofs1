// features/auth/data/models/user_model.dart
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String role; // 'teacher', 'school', 'inspector', 'admin'
  final String plan; // 'free', 'vip', 'premium'
  final DateTime createdAt;
  final DateTime lastLogin;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.role = 'teacher',
    this.plan = 'free',
    required this.createdAt,
    required this.lastLogin,
  });

  // Conversion depuis Firebase User
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? 'no-email',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      role: 'teacher', // À remplacer par la valeur réelle depuis Firestore
      plan: 'free', // À remplacer par la valeur réelle depuis Firestore
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastLogin: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  // Conversion vers Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'plan': plan,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
    };
  }

  // Validation des données
  bool get isValid {
    return uid.isNotEmpty &&
        email.isNotEmpty &&
        ['teacher', 'school', 'inspector', 'admin'].contains(role) &&
        ['free', 'vip', 'premium'].contains(plan);
  }

  // Copie avec modification
  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    String? role,
    String? plan,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      createdAt: createdAt,
      lastLogin: lastLogin,
    );
  }
}
