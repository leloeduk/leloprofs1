import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/domain/entities/user_model.dart';

class SchoolModel extends UserModel {
  // Informations de base
  final String name;
  final String town;
  final String department; // Département/Région (ex: "Yvelines")
  final String country; // Pays (ex: "France")

  // Coordonnées
  final String primaryPhone; // Numéro principal (obligatoire)
  final String? secondaryPhone; // Numéro secondaire (optionnel)
  final String? emergencyPhone; // Numéro d'urgence (optionnel)

  // Gestion des états
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final String creationSource; // 'app' ou 'web'

  // Historique
  final DateTime? schoolCreationDate; // Date de fondation physique
  final int yearOfEstablishment; // Année de création

  // Métadonnées
  final String? profileImage;
  final List<String> jobPosts;
  final List<String> types;
  final double? ratings;
  final List<String> educationCycle;
  final String? bio;

  const SchoolModel({
    // UserModel (hérité)
    required super.uid,
    required super.email,
    String? displayName,
    super.photoUrl,
    super.role = UserRole.school,
    super.plan,
    super.planExpiryDate,

    // SchoolModel
    required this.name,
    required this.town,
    required this.department,
    this.country = 'France', // Valeur par défaut
    required this.primaryPhone,
    this.secondaryPhone,
    this.emergencyPhone,
    this.isActive = true,
    this.isVerified = false,
    required this.createdAt,
    this.creationSource = 'app',
    this.schoolCreationDate,
    required this.yearOfEstablishment,
    this.profileImage,
    this.jobPosts = const [],
    this.types = const [],
    this.ratings,
    this.educationCycle = const [],
    this.bio,
  }) : super(displayName: displayName ?? name);

  factory SchoolModel.fromJson(Map<String, dynamic> json, String id) {
    return SchoolModel(
      // UserModel
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: _parseUserRole(json['role'] as String?),
      plan: _parseUserPlan(json['plan'] as String?),
      planExpiryDate: json['planExpiryDate']?.toDate(),

      // SchoolModel
      name: json['name'] as String,
      town: json['town'] as String,
      department: json['department'] as String,
      country: json['country'] as String? ?? 'France',
      primaryPhone: json['primaryPhone'] as String,
      secondaryPhone: json['secondaryPhone'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      creationSource: json['creationSource'] as String? ?? 'app',
      schoolCreationDate: json['schoolCreationDate']?.toDate(),
      yearOfEstablishment: json['yearOfEstablishment'] as int,
      profileImage: json['profileImage'] as String?,
      jobPosts: List<String>.from(json['jobPosts'] as List? ?? []),
      types: List<String>.from(json['types'] as List? ?? []),
      ratings: json['ratings'] as double?,
      educationCycle: List<String>.from(json['educationCycle'] as List? ?? []),
      bio: json['bio'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      // UserModel
      ...super.toMap(),

      // SchoolModel
      'name': name,
      'town': town,
      'department': department,
      'country': country,
      'primaryPhone': primaryPhone,
      if (secondaryPhone != null) 'secondaryPhone': secondaryPhone,
      if (emergencyPhone != null) 'emergencyPhone': emergencyPhone,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'creationSource': creationSource,
      if (schoolCreationDate != null) 'schoolCreationDate': schoolCreationDate,
      'yearOfEstablishment': yearOfEstablishment,
      if (profileImage != null) 'profileImage': profileImage,
      'jobPosts': jobPosts,
      'types': types,
      if (ratings != null) 'ratings': ratings,
      'educationCycle': educationCycle,
      if (bio != null) 'bio': bio,
    };
  }

  // Getter pratique
  String get fullLocation => '$town, $department, $country';

  // Vérifie si l'école a plusieurs numéros
  bool get hasMultiplePhones =>
      secondaryPhone != null || emergencyPhone != null;

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    town,
    department,
    country,
    primaryPhone,
    secondaryPhone,
    emergencyPhone,
    isActive,
    isVerified,
    createdAt,
    creationSource,
    schoolCreationDate,
    yearOfEstablishment,
    profileImage,
    jobPosts,
    types,
    ratings,
    educationCycle,
    bio,
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
