import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class JobOfferModel extends Equatable {
  final String id;
  final String schoolId;
  final String title;
  final String description;
  final DateTime postedAt;
  final bool isActive;

  const JobOfferModel({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.postedAt,
    required this.isActive,
  });

  factory JobOfferModel.fromMap(Map<String, dynamic> map, String documentId) {
    return JobOfferModel(
      id: documentId,
      schoolId: map['schoolId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      postedAt: (map['postedAt'] as Timestamp).toDate(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'title': title,
      'description': description,
      'postedAt': postedAt,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
    id,
    schoolId,
    title,
    description,
    postedAt,
    isActive,
  ];
}
