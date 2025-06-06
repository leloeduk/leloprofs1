import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ContractType { fullTime, partTime, temporary, internship }

enum SchoolLevel { primary, secondary, highSchool, university }

enum Gender { male, female, other, unspecified }

class JobOfferModel extends Equatable {
  // Identifiants
  final String jobId;
  final DateTime creationDate;
  final DateTime? expirationDate;
  final DateTime? applicationDeadline;

  // Référence à l'école
  final String schoolId;
  final String schoolName;
  final String? schoolLogoUrl;
  final String schoolCountry;
  final String schoolCity;
  final String schoolAddress;

  // Détails de l'offre
  final String title;
  final String description;
  final ContractType contractType;
  final SchoolLevel schoolLevel;

  // Domaines d’enseignement
  final String? teachingDomain;
  final String? subjects;

  // Conditions de travail
  final double? monthlySalary;
  final int? weeklyHours;
  final Gender? requiredGender;

  // Contacts différents
  final String? contactEmail;
  final String? contactPhone;

  // Exigences et avantages
  final List<String> requirements;
  final List<String> benefits;

  // Gestion des candidatures
  final List<String> applicantIds;

  const JobOfferModel({
    required this.jobId,
    required this.creationDate,
    this.expirationDate,
    this.applicationDeadline,
    required this.schoolId,
    required this.schoolName,
    this.schoolLogoUrl,
    required this.schoolCountry,
    required this.schoolCity,
    required this.schoolAddress,
    required this.title,
    required this.description,
    required this.contractType,
    required this.schoolLevel,
    this.teachingDomain,
    this.subjects,
    this.monthlySalary,
    this.weeklyHours,
    this.requiredGender,
    this.contactEmail,
    this.contactPhone,
    this.requirements = const [],
    this.benefits = const [],
    this.applicantIds = const [],
  });

  factory JobOfferModel.fromJson(Map<String, dynamic> json) {
    return JobOfferModel(
      jobId: json['jobId'] ?? '',
      creationDate:
          (json['creationDate'] is Timestamp)
              ? (json['creationDate'] as Timestamp).toDate()
              : DateTime.parse(
                json['creationDate'] ?? DateTime.now().toIso8601String(),
              ),
      expirationDate:
          (json['expirationDate'] is Timestamp)
              ? (json['expirationDate'] as Timestamp).toDate()
              : json['expirationDate'] != null
              ? DateTime.parse(json['expirationDate'])
              : null,
      applicationDeadline:
          (json['applicationDeadline'] is Timestamp)
              ? (json['applicationDeadline'] as Timestamp).toDate()
              : json['applicationDeadline'] != null
              ? DateTime.parse(json['applicationDeadline'])
              : null,
      schoolId: json['schoolId'] ?? '',
      schoolName: json['schoolName'] ?? '',
      schoolLogoUrl: json['schoolLogoUrl'],
      schoolCountry: json['schoolCountry'] ?? '',
      schoolCity: json['schoolCity'] ?? '',
      schoolAddress: json['schoolAddress'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      contractType: _contractTypeFromString(json['contractType']),
      schoolLevel: _schoolLevelFromString(json['schoolLevel']),
      teachingDomain: json['teachingDomain'],
      subjects: json['subjects'],
      monthlySalary: (json['monthlySalary'] as num?)?.toDouble(),
      weeklyHours: json['weeklyHours'],
      requiredGender: _genderFromString(json['requiredGender']),
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      requirements: List<String>.from(json['requirements'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      applicantIds: List<String>.from(json['applicantIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'creationDate': creationDate.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'schoolId': schoolId,
      'schoolName': schoolName,
      'schoolLogoUrl': schoolLogoUrl,
      'schoolCountry': schoolCountry,
      'schoolCity': schoolCity,
      'schoolAddress': schoolAddress,
      'title': title,
      'description': description,
      'contractType': contractType.name,
      'schoolLevel': schoolLevel.name,
      'teachingDomain': teachingDomain,
      'subjects': subjects,
      'monthlySalary': monthlySalary,
      'weeklyHours': weeklyHours,
      'requiredGender': requiredGender?.name,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'requirements': requirements,
      'benefits': benefits,
      'applicantIds': applicantIds,
    };
  }

  JobOfferModel copyWith({
    String? jobId,
    DateTime? creationDate,
    DateTime? expirationDate,
    DateTime? applicationDeadline,
    String? schoolId,
    String? schoolName,
    String? schoolLogoUrl,
    String? schoolCountry,
    String? schoolCity,
    String? schoolAddress,
    String? title,
    String? description,
    ContractType? contractType,
    SchoolLevel? schoolLevel,
    String? teachingDomain,
    String? subjects,
    double? monthlySalary,
    int? weeklyHours,
    Gender? requiredGender,
    String? contactEmail,
    String? contactPhone,
    List<String>? requirements,
    List<String>? benefits,
    List<String>? applicantIds,
  }) {
    return JobOfferModel(
      jobId: jobId ?? this.jobId,
      creationDate: creationDate ?? this.creationDate,
      expirationDate: expirationDate ?? this.expirationDate,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      schoolLogoUrl: schoolLogoUrl ?? this.schoolLogoUrl,
      schoolCountry: schoolCountry ?? this.schoolCountry,
      schoolCity: schoolCity ?? this.schoolCity,
      schoolAddress: schoolAddress ?? this.schoolAddress,
      title: title ?? this.title,
      description: description ?? this.description,
      contractType: contractType ?? this.contractType,
      schoolLevel: schoolLevel ?? this.schoolLevel,
      teachingDomain: teachingDomain ?? this.teachingDomain,
      subjects: subjects ?? this.subjects,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      requiredGender: requiredGender ?? this.requiredGender,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      applicantIds: applicantIds ?? this.applicantIds,
    );
  }

  @override
  List<Object?> get props => [
    jobId,
    creationDate,
    expirationDate,
    applicationDeadline,
    schoolId,
    schoolName,
    schoolLogoUrl,
    schoolCountry,
    schoolCity,
    schoolAddress,
    title,
    description,
    contractType,
    schoolLevel,
    teachingDomain,
    subjects,
    monthlySalary,
    weeklyHours,
    requiredGender,
    contactEmail,
    contactPhone,
    requirements,
    benefits,
    applicantIds,
  ];

  // Helpers pour les enums (convertir string <-> enum)
  static ContractType _contractTypeFromString(String? str) {
    switch (str) {
      case 'fullTime':
        return ContractType.fullTime;
      case 'partTime':
        return ContractType.partTime;
      case 'temporary':
        return ContractType.temporary;
      case 'internship':
        return ContractType.internship;
      default:
        return ContractType.fullTime;
    }
  }

  static SchoolLevel _schoolLevelFromString(String? str) {
    switch (str) {
      case 'primary':
        return SchoolLevel.primary;
      case 'secondary':
        return SchoolLevel.secondary;
      case 'highSchool':
        return SchoolLevel.highSchool;
      case 'university':
        return SchoolLevel.university;
      default:
        return SchoolLevel.primary;
    }
  }

  static Gender? _genderFromString(String? str) {
    switch (str) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;

      default:
        return null;
    }
  }
}
