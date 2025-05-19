import '../../../auth/domain/entities/user_model.dart';

class TeacherModel extends UserModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String department;
  final List<String> diplomas;
  final int yearsOfExperience;
  final List<String> educationCycles;
  final List<String> subjects;
  final List<String> languages;
  final double? rating;
  final bool isAvailable;
  final bool isInspector;

  const TeacherModel({
    required super.uid,
    required this.firstName,
    required this.lastName,
    required super.email,
    required this.phoneNumber,
    required super.photoUrl,
    required this.department,
    required this.diplomas,
    required this.yearsOfExperience,
    required this.educationCycles,
    required this.subjects,
    required this.languages,
    this.rating,
    required this.isAvailable,
    required super.plan,
    this.isInspector = false, // ✅ valeur par défaut
  });

  List<Object?> get props => [
    uid,
    firstName,
    lastName,
    email,
    phoneNumber,
    photoUrl,
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
      uid: docId,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'],
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
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

  //   @override
  //   TeacherModel copyWith({
  //     String? firstName,
  //     String? displayName,
  //     String? lastName,
  //     String? phoneNumber,
  //     String? photoUrl,
  //     String? department,
  //     List<String>? diplomas,
  //     int? yearsOfExperience,
  //     List<String>? educationCycles,
  //     List<String>? subjects,
  //     List<String>? languages,
  //     double? rating,
  //     bool? isAvailable,
  //     String? plan,
  //     bool? isInspector,
  //   }) {
  //     return TeacherModel(
  //       uid: uid ?? this.uid,
  //       firstName: firstName ?? this.firstName,
  //       lastName: lastName ?? this.lastName,
  //       email: email ?? this.email,
  //       phoneNumber: phoneNumber ?? this.phoneNumber,
  //       photoUrl: photoUrl ?? this.photoUrl,
  //       department: department ?? this.department,
  //       diplomas: diplomas ?? this.diplomas,
  //       yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
  //       educationCycles: educationCycles ?? this.educationCycles,
  //       subjects: subjects ?? this.subjects,
  //       languages: languages ?? this.languages,
  //       rating: rating ?? this.rating,
  //       isAvailable: isAvailable ?? this.isAvailable,
  //       plan: plan ?? this.plan,
  //       isInspector: isInspector ?? this.isInspector,
  //     );
  //   }
  // }
}
