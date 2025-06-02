import '../../../auth/domain/entities/user_model.dart';

class TeacherModel extends UserModel {
  // ========== SECTION 1 : INFORMATIONS PERSONNELLES ==========
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String bio;
  final String? secondaryPhone;
  final String? emergencyContact;

  // ========== SECTION 2 : INFORMATIONS PROFESSIONNELLES ==========
  final String department;
  final String? country;
  final String? district;

  // ========== SECTION 3 : DOCUMENTS & CERTIFICATIONS ==========
  final List<String> diplomas;
  final String? diplomaUrl;
  final String? cvUrl;
  final String? profileImageUrl;
  final String? coverPhoto;

  // ========== SECTION 4 : EXPÉRIENCE & COMPÉTENCES ==========
  final int yearsOfExperience;
  final List<String> educationCycles;
  final List<String> subjects;
  final List<String> languages;
  final int workshopParticipationCount;

  // ========== SECTION 5 : STATUT PROFESSIONNEL ==========
  final bool isCivilServant;
  final bool isInspector;
  final bool isAvailable;
  final DateTime? teacherSince;
  final double? rating;

  // ========== SECTION 8 : MÉTADONNÉES ==========
  final DateTime? lastAvailabilityUpdate;
  final DateTime? lastUpdate;

  const TeacherModel({
    // Champs UserModel
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.isNewUser = true,
    super.plan = SubscriptionPlan.free,
    super.hasPaid = false,
    super.isVerified = false,
    super.verifiedAt,
    super.verifiedBy,
    required super.createdAt,
    super.isEnabled = true,

    // Champs TeacherModel
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.bio,
    this.secondaryPhone,
    this.emergencyContact,
    required this.department,
    this.country,
    this.district,
    required this.diplomas,
    this.diplomaUrl,
    this.cvUrl,
    this.profileImageUrl,
    this.coverPhoto,
    required this.yearsOfExperience,
    required this.educationCycles,
    required this.subjects,
    required this.languages,
    required this.workshopParticipationCount,
    required this.isCivilServant,
    required this.isInspector,
    required this.isAvailable,
    this.teacherSince,
    this.rating,
    this.lastAvailabilityUpdate,
    this.lastUpdate,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      // Champs UserModel
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'teacher',
      isNewUser: json['isNewUser'] ?? true,
      plan: _parsePlan(json['plan']),
      hasPaid: json['hasPaid'] ?? false,
      isVerified: json['isVerified'] ?? false,
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.parse(json['verifiedAt'])
              : null,
      verifiedBy: json['verifiedBy'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isEnabled: json['isEnabled'] ?? true,

      // Champs TeacherModel
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      bio: json['bio'] ?? '',
      secondaryPhone: json['secondaryPhone'],
      emergencyContact: json['emergencyContact'],
      department: json['department'] ?? '',
      country: json['country'],
      district: json['district'],
      diplomas: List<String>.from(json['diplomas'] ?? []),
      diplomaUrl: json['diplomaUrl'],
      cvUrl: json['cvUrl'],
      profileImageUrl: json['profileImageUrl'],
      coverPhoto: json['coverPhoto'],
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      educationCycles: List<String>.from(json['educationCycles'] ?? []),
      subjects: List<String>.from(json['subjects'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      workshopParticipationCount: json['workshopParticipationCount'] ?? 0,
      isCivilServant: json['isCivilServant'] ?? false,
      isInspector: json['isInspector'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      teacherSince:
          json['teacherSince'] != null
              ? DateTime.parse(json['teacherSince'])
              : null,
      rating: (json['rating'] != null) ? json['rating'].toDouble() : null,
      lastAvailabilityUpdate:
          json['lastAvailabilityUpdate'] != null
              ? DateTime.parse(json['lastAvailabilityUpdate'])
              : null,
      lastUpdate:
          json['lastUpdate'] != null
              ? DateTime.parse(json['lastUpdate'])
              : null,
    );
  }

  static SubscriptionPlan _parsePlan(String? plan) {
    switch (plan) {
      case 'pro':
        return SubscriptionPlan.pro;
      case 'elite':
        return SubscriptionPlan.elite;
      default:
        return SubscriptionPlan.free;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      // Champs hérités
      ...super.toJson(),

      // Champs spécifiques
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'secondaryPhone': secondaryPhone,
      'emergencyContact': emergencyContact,
      'department': department,
      'country': country,
      'district': district,
      'diplomas': diplomas,
      'diplomaUrl': diplomaUrl,
      'cvUrl': cvUrl,
      'profileImageUrl': profileImageUrl,
      'coverPhoto': coverPhoto,
      'yearsOfExperience': yearsOfExperience,
      'educationCycles': educationCycles,
      'subjects': subjects,
      'languages': languages,
      'workshopParticipationCount': workshopParticipationCount,
      'isCivilServant': isCivilServant,
      'isInspector': isInspector,
      'isAvailable': isAvailable,
      'teacherSince': teacherSince?.toIso8601String(),
      'rating': rating,
      'lastAvailabilityUpdate': lastAvailabilityUpdate?.toIso8601String(),
      'lastUpdate': lastUpdate?.toIso8601String(),
    };
  }

  /// copyWith
  @override
  TeacherModel copyWith({
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

    // Champs TeacherModel
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    String? secondaryPhone,
    String? emergencyContact,
    String? department,
    String? country,
    String? district,
    List<String>? diplomas,
    String? diplomaUrl,
    String? cvUrl,
    String? profileImageUrl,
    String? coverPhoto,
    int? yearsOfExperience,
    List<String>? educationCycles,
    List<String>? subjects,
    List<String>? languages,
    int? workshopParticipationCount,
    bool? isCivilServant,
    bool? isInspector,
    bool? isAvailable,
    DateTime? teacherSince,
    double? rating,
    DateTime? lastAvailabilityUpdate,
    DateTime? lastUpdate,
  }) {
    return TeacherModel(
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

      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      department: department ?? this.department,
      country: country ?? this.country,
      district: district ?? this.district,
      diplomas: diplomas ?? this.diplomas,
      diplomaUrl: diplomaUrl ?? this.diplomaUrl,
      cvUrl: cvUrl ?? this.cvUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      educationCycles: educationCycles ?? this.educationCycles,
      subjects: subjects ?? this.subjects,
      languages: languages ?? this.languages,
      workshopParticipationCount:
          workshopParticipationCount ?? this.workshopParticipationCount,
      isCivilServant: isCivilServant ?? this.isCivilServant,
      isInspector: isInspector ?? this.isInspector,
      isAvailable: isAvailable ?? this.isAvailable,
      teacherSince: teacherSince ?? this.teacherSince,
      rating: rating ?? this.rating,
      lastAvailabilityUpdate:
          lastAvailabilityUpdate ?? this.lastAvailabilityUpdate,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  /// Equatable : pour que `==` fonctionne bien
  @override
  List<Object?> get props => [
    // UserModel props
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

    // TeacherModel props
    firstName,
    lastName,
    phoneNumber,
    bio,
    secondaryPhone,
    emergencyContact,
    department,
    country,
    district,
    diplomas,
    diplomaUrl,
    cvUrl,
    profileImageUrl,
    coverPhoto,
    yearsOfExperience,
    educationCycles,
    subjects,
    languages,
    workshopParticipationCount,
    isCivilServant,
    isInspector,
    isAvailable,
    teacherSince,
    rating,
    lastAvailabilityUpdate,
    lastUpdate,
  ];
}
