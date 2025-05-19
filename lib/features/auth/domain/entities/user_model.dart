import 'package:equatable/equatable.dart'; // Pour simplifier la comparaison d'objets

// Définition des rôles utilisateur sous forme d'enum pour un typage fort
enum UserRole { teacher, school, inspector, admin, visitor }

// Définition des plans d'abonnement disponibles
enum UserPlan { free, vip, premium }

class UserModel extends Equatable {
  // Données de base obligatoires
  final String uid; // Identifiant unique Firebase
  final String email; // Email de l'utilisateur
  final String? displayName; // Nom affiché (optionnel)
  final String? photoUrl; // URL de la photo de profil (optionnel)

  // Gestion des permissions et abonnements
  final UserRole
  role; // Rôle dans l'application (converti automatiquement depuis String)
  final UserPlan plan; // Type d'abonnement
  final DateTime?
  planExpiryDate; // Date d'expiration pour les abonnements temporaires

  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.role = UserRole.teacher, // Valeur par défaut
    this.plan = UserPlan.free, // Valeur par défaut
    this.planExpiryDate,
  });

  // Convertit les données Firestore (Map) en objet UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] as String, // UID obligatoire
      email: json["email"] as String? ?? 'no-email', // Fallback si email null
      displayName: json["displayName"] as String?, // Optionnel
      photoUrl: json["photoUrl"] as String?, // Optionnel
      role: _parseUserRole(json["role"] as String?), // Conversion sécurisée
      plan: _parseUserPlan(json["plan"] as String?), // Conversion sécurisée
      planExpiryDate:
          json["planExpiryDate"]?.toDate(), // Conversion depuis Timestamp
    );
  }

  // Convertit l'objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.name, // Convertit l'enum en String
      'plan': plan.name, // Convertit l'enum en String
      if (planExpiryDate != null)
        'planExpiryDate': planExpiryDate, // Uniquement si non null
    };
  }

  // Vérifie si l'utilisateur a des données valides
  bool get isValid {
    return uid.isNotEmpty &&
        email.isNotEmpty; // Les enums garantissent déjà role/plan valides
  }

  // Vérifie si l'abonnement est encore actif
  bool get isPlanActive {
    return planExpiryDate == null || planExpiryDate!.isAfter(DateTime.now());
  }

  // Crée une copie de l'objet avec certaines valeurs modifiées
  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    UserRole? role,
    UserPlan? plan,
    DateTime? planExpiryDate,
  }) {
    return UserModel(
      uid: uid, // Toujours conservé
      email: email ?? this.email, // Nouvelle valeur ou ancienne si non fournie
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      planExpiryDate: planExpiryDate ?? this.planExpiryDate,
    );
  }

  // Liste des propriétés utilisées pour la comparaison d'objets (Equatable)
  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    role,
    plan,
    planExpiryDate,
  ];

  // Convertit une String en UserRole (avec fallback)
  static UserRole _parseUserRole(String? role) {
    if (role == null) return UserRole.teacher; // Valeur par défaut
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.visitor, // Fallback si valeur inconnue
    );
  }

  // Convertit une String en UserPlan (avec fallback)
  static UserPlan _parseUserPlan(String? plan) {
    if (plan == null) return UserPlan.free; // Valeur par défaut
    return UserPlan.values.firstWhere(
      (e) => e.name == plan,
      orElse: () => UserPlan.free, // Fallback si valeur inconnue
    );
  }
}
