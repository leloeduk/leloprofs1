import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leloprof/features/job/domain/models/joboffer_model.dart';

import '../../domain/repositories/joboffer_repository.dart';

class FirebaseJobofferRepos implements JobOfferRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get _jobOffersRef => firestore.collection('jobOffers');

  @override
  Future<List<JobOfferModel>> fetchAllJobOffers() async {
    final snapshot = await _jobOffersRef.get();
    return snapshot.docs
        .map(
          (doc) => JobOfferModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> createJobOffer(JobOfferModel jobOffer) async {
    await _jobOffersRef.doc(jobOffer.id).set(jobOffer.toJson());
  }

  @override
  Future<void> updateJobOffer(JobOfferModel jobOffer) async {
    await _jobOffersRef.doc(jobOffer.id).update(jobOffer.toJson());
  }

  @override
  Future<void> deleteJobOffer(String id) async {
    await _jobOffersRef.doc(id).delete();
  }

  @override
  Future<JobOfferModel?> getJobOfferById(String id) async {
    final doc = await _jobOffersRef.doc(id).get();
    if (doc.exists) {
      return JobOfferModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
