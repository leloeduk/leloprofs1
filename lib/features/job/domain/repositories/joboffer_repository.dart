import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/joboffer_model.dart';

abstract class JobOfferRepository {
  CollectionReference<Map<String, dynamic>> get collectionRef;

  Future<List<JobOfferModel>> fetchAllJobOffers(String? schoolId);
  Future<void> createJobOffer(JobOfferModel offer);
  Future<bool> updateJobOffer(JobOfferModel jobOffer);
  Future<bool> deleteJobOffer(String id);
  Future<void> applyForJob(String jobOfferId);
  Future<JobOfferModel?> getJobOfferById(String id);
}
