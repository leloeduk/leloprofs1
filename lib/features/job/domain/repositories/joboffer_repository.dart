import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/joboffer_model.dart';

abstract class JobOfferRepository {
  CollectionReference<Map<String, dynamic>> get collectionRef;

  Future<List<JobOfferModel>> fetchAllJobOffers(String? schoolId);
  Future<void> createJobOffer(JobOfferModel offer);
  Future<void> updateJobOffer(JobOfferModel jobOffer);
  Future<void> deleteJobOffer(String id);
  Future<JobOfferModel?> getJobOfferById(String id);
}
