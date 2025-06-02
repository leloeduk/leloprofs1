import '../../../auth/domain/entities/user_model.dart';

class SchoolModel extends UserModel {
  final String town;
  final String department;
  final String country;
  final String primaryPhone;
  final String? secondaryPhone;

  final String? profileImageUrl;
  final String? coverImage;
  final String? bio;
  final double? ratings;

  final DateTime? lastUpdate;
  final DateTime? schoolCreationDate;
  final int yearOfEstablishment;
  final List<String> jobPosts;
  final List<String> types;
  final List<String> educationCycle;

  final List<String> diplomas;
  final List<String> languages;
  final List<String> facilities;
  final String? websiteUrl;
  final String? inspectionReportUrl;
  final int teacherCount;
  final int studentCount;
  final String? pedagogicalApproach;
  final bool isPublic;
  final String? accreditationNumber;

  const SchoolModel({
    // Champs de UserModel
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

    // Champs spécifiques à SchoolModel
    required this.town,
    required this.department,
    required this.country,
    required this.primaryPhone,
    this.secondaryPhone,
    this.profileImageUrl,
    this.coverImage,
    this.bio,
    this.ratings,
    this.lastUpdate,
    this.schoolCreationDate,
    required this.yearOfEstablishment,
    required this.jobPosts,
    required this.types,
    required this.educationCycle,
    this.diplomas = const [],
    this.languages = const [],
    this.facilities = const [],
    this.websiteUrl,
    this.inspectionReportUrl,
    this.teacherCount = 0,
    this.studentCount = 0,
    this.pedagogicalApproach,
    required this.isPublic,
    this.accreditationNumber,
  });

  /// Désérialisation JSON
  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      // UserModel
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'school',
      isNewUser: json['isNewUser'] ?? true,
      plan:
          json['plan'] == 'pro'
              ? SubscriptionPlan.pro
              : json['plan'] == 'elite'
              ? SubscriptionPlan.elite
              : SubscriptionPlan.free,
      hasPaid: json['hasPaid'] ?? false,
      isVerified: json['isVerified'] ?? false,
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.parse(json['verifiedAt'])
              : null,
      verifiedBy: json['verifiedBy'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      isEnabled: json['isEnabled'] ?? true,

      // SchoolModel
      town: json['town'] ?? '',
      department: json['department'] ?? '',
      country: json['country'] ?? '',
      primaryPhone: json['primaryPhone'] ?? '',
      secondaryPhone: json['secondaryPhone'],
      profileImageUrl: json['profileImageUrl'],
      coverImage: json['coverImage'],
      bio: json['bio'],
      ratings: (json['ratings'] as num?)?.toDouble(),
      lastUpdate:
          json['lastUpdate'] != null
              ? DateTime.parse(json['lastUpdate'])
              : null,
      schoolCreationDate:
          json['schoolCreationDate'] != null
              ? DateTime.parse(json['schoolCreationDate'])
              : null,
      yearOfEstablishment: json['yearOfEstablishment'] ?? 2000,
      jobPosts: List<String>.from(json['jobPosts'] ?? []),
      types: List<String>.from(json['types'] ?? []),
      educationCycle: List<String>.from(json['educationCycle'] ?? []),
      diplomas: List<String>.from(json['diplomas'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      websiteUrl: json['websiteUrl'],
      inspectionReportUrl: json['inspectionReportUrl'],
      teacherCount: json['teacherCount'] ?? 0,
      studentCount: json['studentCount'] ?? 0,
      pedagogicalApproach: json['pedagogicalApproach'],
      isPublic: json['isPublic'] ?? false,
      accreditationNumber: json['accreditationNumber'],
    );
  }

  /// Sérialisation JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      // UserModel
      ...super.toJson(),
      // SchoolModel
      'town': town,
      'department': department,
      'country': country,
      'primaryPhone': primaryPhone,
      'secondaryPhone': secondaryPhone,
      'profileImageUrl': profileImageUrl,
      'coverImage': coverImage,
      'bio': bio,
      'ratings': ratings,
      'lastUpdate': lastUpdate?.toIso8601String(),
      'schoolCreationDate': schoolCreationDate?.toIso8601String(),
      'yearOfEstablishment': yearOfEstablishment,
      'jobPosts': jobPosts,
      'types': types,
      'educationCycle': educationCycle,
      'diplomas': diplomas,
      'languages': languages,
      'facilities': facilities,
      'websiteUrl': websiteUrl,
      'inspectionReportUrl': inspectionReportUrl,
      'teacherCount': teacherCount,
      'studentCount': studentCount,
      'pedagogicalApproach': pedagogicalApproach,
      'isPublic': isPublic,
      'accreditationNumber': accreditationNumber,
    };
  }

  @override
  SchoolModel copyWith({
    // Champs de UserModel
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

    // Champs SchoolModel
    String? town,
    String? department,
    String? country,
    String? primaryPhone,
    String? secondaryPhone,
    String? profileImageUrl,
    String? coverImage,
    String? bio,
    double? ratings,
    DateTime? lastUpdate,
    DateTime? schoolCreationDate,
    int? yearOfEstablishment,
    List<String>? jobPosts,
    List<String>? types,
    List<String>? educationCycle,
    List<String>? diplomas,
    List<String>? languages,
    List<String>? facilities,
    String? websiteUrl,
    String? inspectionReportUrl,
    int? teacherCount,
    int? studentCount,
    String? pedagogicalApproach,
    bool? isPublic,
    String? accreditationNumber,
  }) {
    return SchoolModel(
      // Champs de UserModel
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

      // Champs SchoolModel
      town: town ?? this.town,
      department: department ?? this.department,
      country: country ?? this.country,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImage: coverImage ?? this.coverImage,
      bio: bio ?? this.bio,
      ratings: ratings ?? this.ratings,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      schoolCreationDate: schoolCreationDate ?? this.schoolCreationDate,
      yearOfEstablishment: yearOfEstablishment ?? this.yearOfEstablishment,
      jobPosts: jobPosts ?? this.jobPosts,
      types: types ?? this.types,
      educationCycle: educationCycle ?? this.educationCycle,
      diplomas: diplomas ?? this.diplomas,
      languages: languages ?? this.languages,
      facilities: facilities ?? this.facilities,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      inspectionReportUrl: inspectionReportUrl ?? this.inspectionReportUrl,
      teacherCount: teacherCount ?? this.teacherCount,
      studentCount: studentCount ?? this.studentCount,
      pedagogicalApproach: pedagogicalApproach ?? this.pedagogicalApproach,
      isPublic: isPublic ?? this.isPublic,
      accreditationNumber: accreditationNumber ?? this.accreditationNumber,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    town,
    department,
    country,
    primaryPhone,
    secondaryPhone,
    profileImageUrl,
    coverImage,
    bio,
    ratings,
    lastUpdate,
    schoolCreationDate,
    yearOfEstablishment,
    jobPosts,
    types,
    educationCycle,
    diplomas,
    languages,
    facilities,
    websiteUrl,
    inspectionReportUrl,
    teacherCount,
    studentCount,
    pedagogicalApproach,
    isPublic,
    accreditationNumber,
  ];
}
