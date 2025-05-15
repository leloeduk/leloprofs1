import 'package:equatable/equatable.dart';

class SchoolModel extends Equatable {
  final String id;
  final String name;
  final String town;
  final String? email;
  final String phoneNumber;
  final String? profileImage;
  final List<String> jobPosts;
  final bool enable;
  final bool isPay;
  final bool isPremium;
  final List<String> types;
  final String department;
  final double? ratings;
  final List<String> educationCycle;
  final int yearOfEstablishment;
  final String? bio;
  final String plan; // Nouveau champ ajouté

  const SchoolModel({
    required this.id,
    required this.name,
    required this.town,
    this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.jobPosts,
    required this.enable,
    required this.isPay,
    required this.isPremium,
    required this.types,
    required this.department,
    this.ratings,
    required this.educationCycle,
    required this.yearOfEstablishment,
    this.bio,
    this.plan = 'free', // valeur par défaut
  });

  @override
  List<Object?> get props => [
    id,
    name,
    town,
    email,
    phoneNumber,
    profileImage,
    jobPosts,
    enable,
    isPay,
    isPremium,
    types,
    department,
    ratings,
    educationCycle,
    yearOfEstablishment,
    bio,
    plan,
  ];

  factory SchoolModel.fromMap(Map<String, dynamic> map, String docId) {
    return SchoolModel(
      id: docId,
      name: map['name'] as String? ?? '',
      town: map['town'] as String? ?? '',
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String? ?? '',
      profileImage: map['profileImage'] as String?,
      jobPosts: List<String>.from(map['jobPosts'] ?? []),
      enable: map['enable'] as bool? ?? true,
      isPay: map['isPay'] as bool? ?? false,
      isPremium: map['isPremium'] as bool? ?? false,
      types: List<String>.from(map['types'] ?? []),
      department: map['department'] as String? ?? '',
      ratings: (map['ratings'] as num?)?.toDouble(),
      educationCycle: List<String>.from(map['educationCycle'] ?? []),
      yearOfEstablishment: map['yearOfEstablishment'] as int? ?? 0,
      bio: map['bio'] as String?,
      plan: map['plan'] as String? ?? 'free',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'town': town,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'jobPosts': jobPosts,
      'enable': enable,
      'isPay': isPay,
      'isPremium': isPremium,
      'types': types,
      'department': department,
      'ratings': ratings,
      'educationCycle': educationCycle,
      'yearOfEstablishment': yearOfEstablishment,
      'bio': bio,
      'plan': plan,
    };
  }

  SchoolModel copyWith({
    String? id,
    String? name,
    String? town,
    String? email,
    String? phoneNumber,
    String? profileImage,
    List<String>? jobPosts,
    bool? enable,
    bool? isPay,
    bool? isPremium,
    List<String>? types,
    String? department,
    double? ratings,
    List<String>? educationCycle,
    int? yearOfEstablishment,
    String? bio,
    String? plan,
  }) {
    return SchoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      town: town ?? this.town,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      jobPosts: jobPosts ?? this.jobPosts,
      enable: enable ?? this.enable,
      isPay: isPay ?? this.isPay,
      isPremium: isPremium ?? this.isPremium,
      types: types ?? this.types,
      department: department ?? this.department,
      ratings: ratings ?? this.ratings,
      educationCycle: educationCycle ?? this.educationCycle,
      yearOfEstablishment: yearOfEstablishment ?? this.yearOfEstablishment,
      bio: bio ?? this.bio,
      plan: plan ?? this.plan,
    );
  }

  @override
  String toString() {
    return 'School($name, town: $town, plan: $plan)';
  }
}
