import 'package:equatable/equatable.dart';

class TeacherModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String department;
  final List<String> diplomas;
  final int yearsOfExperience;
  final List<String> educationCycles;
  final List<String> subjects;
  final List<String> languages;
  final double? rating;
  final bool isAvailable;
  final String plan;
  final bool isInspector;

  const TeacherModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.department,
    required this.diplomas,
    required this.yearsOfExperience,
    required this.educationCycles,
    required this.subjects,
    required this.languages,
    this.rating,
    required this.isAvailable,
    this.plan = 'free',
    this.isInspector = false, // ✅ valeur par défaut
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phoneNumber,
    profileImage,
    department,
    diplomas,
    yearsOfExperience,
    educationCycles,
    subjects,
    languages,
    rating,
    isAvailable,
    plan,
    isInspector,
  ];

  factory TeacherModel.fromMap(Map<String, dynamic> map, String docId) {
    return TeacherModel(
      id: docId,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImage: map['profileImage'],
      department: map['department'] ?? '',
      diplomas: List<String>.from(map['diplomas'] ?? []),
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
      educationCycles: List<String>.from(map['educationCycles'] ?? []),
      subjects: List<String>.from(map['subjects'] ?? []),
      languages: List<String>.from(map['languages'] ?? []),
      rating: (map['rating'] as num?)?.toDouble(),
      isAvailable: map['isAvailable'] ?? true,
      plan: map['plan'] ?? 'free',
      isInspector: map['isInspector'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'department': department,
      'diplomas': diplomas,
      'yearsOfExperience': yearsOfExperience,
      'educationCycles': educationCycles,
      'subjects': subjects,
      'languages': languages,
      'rating': rating,
      'isAvailable': isAvailable,
      'plan': plan,
      'isInspector': isInspector,
    };
  }

  TeacherModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? department,
    List<String>? diplomas,
    int? yearsOfExperience,
    List<String>? educationCycles,
    List<String>? subjects,
    List<String>? languages,
    double? rating,
    bool? isAvailable,
    String? plan,
    bool? isInspector,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      department: department ?? this.department,
      diplomas: diplomas ?? this.diplomas,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      educationCycles: educationCycles ?? this.educationCycles,
      subjects: subjects ?? this.subjects,
      languages: languages ?? this.languages,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      plan: plan ?? this.plan,
      isInspector: isInspector ?? this.isInspector,
    );
  }
}
