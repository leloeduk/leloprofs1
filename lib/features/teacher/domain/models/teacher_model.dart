import '../../../auth/domain/entities/user_model.dart';

class TeacherModel extends UserModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String department;
  final String? country;
  final String? secondaryPhone;
  final String? emergencyContact;
  final List<String> diplomas;
  final int yearsOfExperience;
  final String? profileImageUrl;
  final List<String> educationCycles;
  final List<String> subjects;
  final List<String> languages;
  final double? rating;
  final bool isAvailable;
  final bool isInspector;
  final DateTime createdAt;
  final DateTime? teacherSince;
  final DateTime? lastAvailabilityUpdate;

  const TeacherModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.department,
    this.country,
    this.secondaryPhone,
    this.emergencyContact,
    required this.diplomas,
    required this.yearsOfExperience,
    this.profileImageUrl,
    required this.educationCycles,
    required this.subjects,
    required this.languages,
    this.rating,
    required this.isAvailable,
    required this.isInspector,
    required this.createdAt,
    this.teacherSince,
    this.lastAvailabilityUpdate,
  });

  @override
  TeacherModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isNewUser,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? department,
    String? country,
    String? secondaryPhone,
    String? emergencyContact,
    List<String>? diplomas,
    int? yearsOfExperience,
    String? profileImageUrl,
    List<String>? educationCycles,
    List<String>? subjects,
    List<String>? languages,
    double? rating,
    bool? isAvailable,
    bool? isInspector,
    DateTime? createdAt,
    DateTime? teacherSince,
    DateTime? lastAvailabilityUpdate,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      country: country ?? this.country,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      diplomas: diplomas ?? this.diplomas,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      educationCycles: educationCycles ?? this.educationCycles,
      subjects: subjects ?? this.subjects,
      languages: languages ?? this.languages,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      isInspector: isInspector ?? this.isInspector,
      createdAt: createdAt ?? this.createdAt,
      teacherSince: teacherSince ?? this.teacherSince,
      lastAvailabilityUpdate:
          lastAvailabilityUpdate ?? this.lastAvailabilityUpdate,
    );
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      department: map['department'],
      country: map['country'],
      secondaryPhone: map['secondaryPhone'],
      emergencyContact: map['emergencyContact'],
      diplomas: List<String>.from(map['diplomas'] ?? []),
      yearsOfExperience: map['yearsOfExperience']?.toInt() ?? 0,
      profileImageUrl: map['profileImageUrl'],
      educationCycles: List<String>.from(map['educationCycles']),
      subjects: List<String>.from(map['subjects']),
      languages: List<String>.from(map['languages']),
      rating: map['rating']?.toDouble(),
      isAvailable: map['isAvailable'],
      isInspector: map['isInspector'],
      createdAt: DateTime.parse(map['createdAt']),
      teacherSince:
          map['teacherSince'] != null
              ? DateTime.parse(map['teacherSince'])
              : null,
      lastAvailabilityUpdate:
          map['lastAvailabilityUpdate'] != null
              ? DateTime.parse(map['lastAvailabilityUpdate'])
              : null,
    );
  }

  Map<String, dynamic> toMap() => {
    ...super.toJson(),
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'department': department,
    'country': country,
    'secondaryPhone': secondaryPhone,
    'emergencyContact': emergencyContact,
    'diplomas': diplomas,
    'yearsOfExperience': yearsOfExperience,
    'profileImageUrl': profileImageUrl,
    'educationCycles': educationCycles,
    'subjects': subjects,
    'languages': languages,
    'rating': rating,
    'isAvailable': isAvailable,
    'isInspector': isInspector,
    'createdAt': createdAt.toIso8601String(),
    'teacherSince': teacherSince?.toIso8601String(),
    'lastAvailabilityUpdate': lastAvailabilityUpdate?.toIso8601String(),
  };

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
    profileImageUrl,
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
}
