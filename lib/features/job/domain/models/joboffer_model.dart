import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class JobOfferModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String schoolId;
  final String schoolName;
  final String? schoolLogo;
  final String contractType; // CDI, CDD, Stage, etc.
  final String domain; // Domaine d'enseignement
  final String location; // Ville ou télétravail
  final double salary; // Salaire mensuel
  final int hoursPerWeek;
  final DateTime date;
  final List<String> requirements;
  final List<String> benefits;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final DateTime? expirationDate;

  const JobOfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.schoolId,
    required this.schoolName,
    this.schoolLogo,
    required this.contractType,
    required this.domain,
    required this.location,
    required this.salary,
    required this.hoursPerWeek,
    required this.date,
    this.requirements = const [],
    this.benefits = const [],
    this.contactEmail,
    this.contactPhone,
    this.website,
    this.expirationDate,
  });

  // Formatteur pour la date
  String get formattedDate => DateFormat('dd/MM/yyyy').format(date);
  String get longFormattedDate =>
      DateFormat('dd MMMM yyyy', 'fr_FR').format(date);

  // Vérifie si l'offre est expirée
  bool get isExpired =>
      expirationDate != null && DateTime.now().isAfter(expirationDate!);

  // Copie avec modification
  JobOfferModel copyWith({
    String? id,
    String? title,
    String? description,
    String? schoolId,
    String? schoolName,
    String? schoolLogo,
    String? contractType,
    String? domain,
    String? location,
    double? salary,
    int? hoursPerWeek,
    DateTime? date,
    List<String>? requirements,
    List<String>? benefits,
    String? contactEmail,
    String? contactPhone,
    String? website,
    DateTime? expirationDate,
  }) {
    return JobOfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      schoolLogo: schoolLogo ?? this.schoolLogo,
      contractType: contractType ?? this.contractType,
      domain: domain ?? this.domain,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
      date: date ?? this.date,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  // Conversion depuis/towards JSON
  factory JobOfferModel.fromJson(Map<String, dynamic> json) {
    return JobOfferModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      schoolId: json['schoolId'] as String,
      schoolName: json['schoolName'] as String,
      schoolLogo: json['schoolLogo'] as String?,
      contractType: json['contractType'] as String,
      domain: json['domain'] as String,
      location: json['location'] as String,
      salary: (json['salary'] as num).toDouble(),
      hoursPerWeek: json['hoursPerWeek'] as int,
      date: DateTime.parse(json['date'] as String),
      requirements: List<String>.from(json['requirements'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      expirationDate:
          json['expirationDate'] != null
              ? DateTime.parse(json['expirationDate'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'schoolLogo': schoolLogo,
      'contractType': contractType,
      'domain': domain,
      'location': location,
      'salary': salary,
      'hoursPerWeek': hoursPerWeek,
      'date': date.toIso8601String(),
      'requirements': requirements,
      'benefits': benefits,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'website': website,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    schoolId,
    schoolName,
    schoolLogo,
    contractType,
    domain,
    location,
    salary,
    hoursPerWeek,
    date,
    requirements,
    benefits,
    contactEmail,
    contactPhone,
    website,
    expirationDate,
  ];
}
