import 'package:equatable/equatable.dart';

enum SubscriptionPlan { free, pro, elite } // Les 3 plans simplifiés

/// Modèle de base pour un utilisateur, étend Equatable pour la comparaison d'égalité
class UserModel extends Equatable {
  final String id; // Identifiant unique
  final String name; // Nom complet
  final String email; // Adresse email
  final String role; // "teacher", "school", "visitor"
  final bool? isNewUser; // Première connexion
  final SubscriptionPlan plan; // Nouveau : type d'abonnement
  final bool hasPaid; // Nouveau : statut paiement
  final bool isVerified; // Vérification manuelle par admin
  final DateTime? verifiedAt; // Date de vérification
  final String? verifiedBy; // Admin qui a vérifié
  final DateTime createdAt; // Date de création
  final bool isEnabled; // Compte activé/désactivé

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isNewUser = true,
    this.plan = SubscriptionPlan.free, // Gratuit par défaut
    this.hasPaid = false, // Non payé par défaut
    this.isVerified = false, // Non vérifié par défaut
    this.verifiedAt,
    this.verifiedBy,
    required this.createdAt,
    this.isEnabled = true, // Activé par défaut
  });

  /// Factory pour la désérialisation depuis JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'visitor',
      isNewUser: json['isNewUser'] as bool? ?? true,
      plan:
          json['plan'] == 'pro'
              ? SubscriptionPlan.pro
              : json['plan'] == 'elite'
              ? SubscriptionPlan.elite
              : SubscriptionPlan.free,
      hasPaid: json['hasPaid'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.parse(json['verifiedAt'])
              : null,
      verifiedBy: json['verifiedBy'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  /// Sérialisation en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isNewUser': isNewUser,
      'plan': plan.name, // Convertit l'enum en String
      'hasPaid': hasPaid,
      'isVerified': isVerified,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'verifiedBy': verifiedBy,
      'createdAt': createdAt.toIso8601String(),
      'isEnabled': isEnabled,
    };
  }

  /// Méthode pour créer une copie avec modifications
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isNewUser,
    SubscriptionPlan? plan,
    bool? hasPaid,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? createdAt,
    bool? isEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isNewUser: isNewUser ?? this.isNewUser,
      plan: plan ?? this.plan,
      hasPaid: hasPaid ?? this.hasPaid,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      createdAt: createdAt ?? this.createdAt,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// Propriétés pour la comparaison d'égalité
  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    isNewUser,
    plan,
    hasPaid,
    isVerified,
    verifiedAt,
    verifiedBy,
    createdAt,
    isEnabled,
  ];
}
