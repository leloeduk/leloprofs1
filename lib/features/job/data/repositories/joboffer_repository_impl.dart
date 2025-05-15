import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leloprof/features/job/data/models/joboffer_model.dart';

import 'joboffer_repository.dart';

class JobOfferRepositoryImpl implements JobOfferRepository {
  final FirebaseFirestore firestore;

  JobOfferRepositoryImpl({required this.firestore});

  CollectionReference get _jobOffersRef => firestore.collection('jobOffers');

  @override
  Future<List<JobOfferModel>> fetchAllJobOffers() async {
    final snapshot = await _jobOffersRef.get();
    return snapshot.docs
        .map(
          (doc) =>
              JobOfferModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  @override
  Future<void> createJobOffer(JobOfferModel jobOffer) async {
    await _jobOffersRef.doc(jobOffer.id).set(jobOffer.toMap());
  }

  @override
  Future<void> updateJobOffer(JobOfferModel jobOffer) async {
    await _jobOffersRef.doc(jobOffer.id).update(jobOffer.toMap());
  }

  @override
  Future<void> deleteJobOffer(String id) async {
    await _jobOffersRef.doc(id).delete();
  }

  @override
  Future<JobOfferModel?> getJobOfferById(String id) async {
    final doc = await _jobOffersRef.doc(id).get();
    if (doc.exists) {
      return JobOfferModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
