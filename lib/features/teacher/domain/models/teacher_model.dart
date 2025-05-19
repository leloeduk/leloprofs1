import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/domain/entities/user_model.dart';

class TeacherModel extends UserModel {
  // Informations personnelles
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String department;
  final String? country; // Nouveau champ pays

  // Coordonnées supplémentaires
  final String? secondaryPhone; // Nouveau numéro secondaire
  final String? emergencyContact; // Nouveau contact d'urgence

  // Professionnel
  final List<String> diplomas;
  final int yearsOfExperience;
  final List<String> educationCycles;
  final List<String> subjects;
  final List<String> languages;
  final double? rating;

  // Statut
  final bool isAvailable;
  final bool isInspector;

  // Dates importantes
  final DateTime createdAt; // Date de création du compte
  final DateTime? teacherSince; // Date de début dans l'enseignement
  final DateTime?
  lastAvailabilityUpdate; // Dernière modification de disponibilité

  const TeacherModel({
    // UserModel (hérité)
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    UserRole role = UserRole.teacher,
    UserPlan plan = UserPlan.free,
    DateTime? planExpiryDate,

    // TeacherModel
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.department,
    this.country,
    this.secondaryPhone,
    this.emergencyContact,
    this.diplomas = const [],
    this.yearsOfExperience = 0,
    this.educationCycles = const [],
    this.subjects = const [],
    this.languages = const [],
    this.rating,
    this.isAvailable = true,
    this.isInspector = false,
    required this.createdAt,
    this.teacherSince,
    this.lastAvailabilityUpdate,
  }) : super(
         uid: uid,
         email: email,
         displayName:
             displayName ?? '$firstName $lastName', // Nom complet par défaut
         photoUrl: photoUrl,
         role:
             isInspector
                 ? UserRole.inspector
                 : role, // Auto-promotion si inspecteur
         plan: plan,
         planExpiryDate: planExpiryDate,
       );

  factory TeacherModel.fromJson(Map<String, dynamic> json, String id) {
    return TeacherModel(
      // UserModel
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: _parseUserRole(json['role'] as String?),
      plan: _parseUserPlan(json['plan'] as String?),
      planExpiryDate: json['planExpiryDate']?.toDate(),

      // TeacherModel
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      department: json['department'] as String,
      country: json['country'] as String?,
      secondaryPhone: json['secondaryPhone'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      diplomas: List<String>.from(json['diplomas'] as List? ?? []),
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      educationCycles: List<String>.from(
        json['educationCycles'] as List? ?? [],
      ),
      subjects: List<String>.from(json['subjects'] as List? ?? []),
      languages: List<String>.from(json['languages'] as List? ?? []),
      rating: json['rating'] as double?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isInspector: json['isInspector'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      teacherSince: json['teacherSince']?.toDate(),
      lastAvailabilityUpdate: json['lastAvailabilityUpdate']?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      // UserModel
      ...super.toMap(),

      // TeacherModel
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'department': department,
      if (country != null) 'country': country,
      if (secondaryPhone != null) 'secondaryPhone': secondaryPhone,
      if (emergencyContact != null) 'emergencyContact': emergencyContact,
      'diplomas': diplomas,
      'yearsOfExperience': yearsOfExperience,
      'educationCycles': educationCycles,
      'subjects': subjects,
      'languages': languages,
      if (rating != null) 'rating': rating,
      'isAvailable': isAvailable,
      'isInspector': isInspector,
      'createdAt': createdAt,
      if (teacherSince != null) 'teacherSince': teacherSince,
      if (lastAvailabilityUpdate != null)
        'lastAvailabilityUpdate': lastAvailabilityUpdate,
    };
  }

  // Getter pratique
  String get fullName => '$firstName $lastName';
  String? get location =>
      country != null ? '$department, $country' : department;

  // Calcul de l'expérience réelle
  int get actualExperience {
    return teacherSince != null
        ? DateTime.now().difference(teacherSince!).inDays ~/ 365
        : yearsOfExperience;
  }

  @override
  List<Object?> get props => [
    ...super.props,
    firstName,
    lastName,
    phoneNumber,
    department,
    country,
    secondaryPhone,
    emergencyContact,
    diplomas,
    yearsOfExperience,
    educationCycles,
    subjects,
    languages,
    rating,
    isAvailable,
    isInspector,
    createdAt,
    teacherSince,
    lastAvailabilityUpdate,
  ];
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
