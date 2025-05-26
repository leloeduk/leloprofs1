import '../../../auth/domain/entities/user_model.dart';

class SchoolModel extends UserModel {
  final String town;
  final String department;
  final String country;
  final String primaryPhone;
  final String? secondaryPhone;
  final String? emergencyPhone;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final String creationSource;
  final String? profileImageUrl; // Renommé depuis profileImage pour cohérence
  final DateTime? schoolCreationDate;
  final int yearOfEstablishment;
  final List<String> jobPosts;
  final List<String> types;
  final double? ratings;
  final List<String> educationCycle;
  final String? bio;
  const SchoolModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required this.town,
    required this.department,
    required this.country,
    required this.primaryPhone,
    this.secondaryPhone,
    this.emergencyPhone,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    required this.creationSource,
    this.profileImageUrl,
    this.schoolCreationDate,
    required this.yearOfEstablishment,
    required this.jobPosts,
    required this.types,
    this.ratings,
    required this.educationCycle,
    this.bio,
  });

  @override
  SchoolModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isNewUser,
    String? town,
    String? department,
    String? country,
    String? primaryPhone,
    String? secondaryPhone,
    String? emergencyPhone,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    String? creationSource,
    String? profileImageUrl,
    DateTime? schoolCreationDate,
    int? yearOfEstablishment,
    List<String>? jobPosts,
    List<String>? types,
    double? ratings,
    List<String>? educationCycle,
    String? bio,
  }) {
    return SchoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      town: town ?? this.town,
      department: department ?? this.department,
      country: country ?? this.country,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      creationSource: creationSource ?? this.creationSource,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolCreationDate: schoolCreationDate ?? this.schoolCreationDate,
      yearOfEstablishment: yearOfEstablishment ?? this.yearOfEstablishment,
      jobPosts: jobPosts ?? this.jobPosts,
      types: types ?? this.types,
      ratings: ratings ?? this.ratings,
      educationCycle: educationCycle ?? this.educationCycle,
      bio: bio ?? this.bio,
    );
  }

  factory SchoolModel.fromJson(Map<String, dynamic> map) {
    return SchoolModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      town: map['town'],
      department: map['department'],
      country: map['country'],
      primaryPhone: map['primaryPhone'],
      secondaryPhone: map['secondaryPhone'],
      emergencyPhone: map['emergencyPhone'],
      isActive: map['isActive'],
      isVerified: map['isVerified'],
      createdAt: DateTime.parse(map['createdAt']),
      creationSource: map['creationSource'] ?? 'unknown',
      profileImageUrl: map['profileImageUrl'], // Ajouté
      schoolCreationDate:
          map['schoolCreationDate'] != null
              ? DateTime.parse(map['schoolCreationDate'])
              : null,
      yearOfEstablishment: map['yearOfEstablishment']?.toInt() ?? 0,
      jobPosts: List<String>.from(map['jobPosts'] ?? []),
      types: List<String>.from(map['types'] ?? []),
      ratings: map['ratings']?.toDouble(),
      educationCycle: List<String>.from(map['educationCycle']),
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() => {
    ...super.toJson(),
    'town': town,
    'department': department,
    'country': country,
    'primaryPhone': primaryPhone,
    'secondaryPhone': secondaryPhone,
    'emergencyPhone': emergencyPhone,
    'isActive': isActive,
    'isVerified': isVerified,
    'createdAt': createdAt.toIso8601String(),
    'creationSource': creationSource,
    'profileImageUrl': profileImageUrl, // Ajouté
    'schoolCreationDate': schoolCreationDate?.toIso8601String(),
    'yearOfEstablishment': yearOfEstablishment,
    'jobPosts': jobPosts,
    'types': types,
    'ratings': ratings,
    'educationCycle': educationCycle,
    'bio': bio,
  };

  @override
  List<Object?> get props => [
    ...super.props,
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
    profileImageUrl,
    schoolCreationDate,
    yearOfEstablishment,
    jobPosts,
    types,
    ratings,
    educationCycle,
    bio,
  ];
}
