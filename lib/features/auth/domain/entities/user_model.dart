import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  // "teacher", "school", or "visitor"
  final bool? isNewUser;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isNewUser = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'visitor',
      isNewUser: json['isNewUser'] as bool? ?? true, // Correction ici
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isNewUser': isNewUser,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isNewUser,
    // autres champs...
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isNewUser: isNewUser ?? this.isNewUser,
      // autres champs...
    );
  }

  @override
  List<Object?> get props => [id, name, email, role, isNewUser];
}
