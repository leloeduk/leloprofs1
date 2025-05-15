import '../models/joboffer_model.dart';

abstract class JobOfferRepository {
  Future<List<JobOfferModel>> fetchAllJobOffers();
  Future<void> createJobOffer(JobOfferModel jobOffer);
  Future<void> updateJobOffer(JobOfferModel jobOffer);
  Future<void> deleteJobOffer(String id);
  Future<JobOfferModel?> getJobOfferById(String id);
}
