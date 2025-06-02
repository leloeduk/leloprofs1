import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/joboffer_model.dart';
import '../../domain/repositories/joboffer_repository.dart';

class FirebaseJobofferRepos implements JobOfferRepository {
  final CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore
      .instance
      .collection('jobOffers');

  final CollectionReference<Map<String, dynamic>> schoolCollection =
      FirebaseFirestore.instance.collection('schools');

  @override
  Future<List<JobOfferModel>> fetchAllJobOffers([String? schoolId]) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (schoolId != null) {
      // Filtrer par schoolId
      snapshot = await collection.where('schoolId', isEqualTo: schoolId).get();
    } else {
      // Récupérer toutes les offres
      snapshot = await collection.get();
    }

    return snapshot.docs
        .map((doc) => JobOfferModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<JobOfferModel?> getJobOfferById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return JobOfferModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> createJobOffer(JobOfferModel offer) async {
    final id = offer.jobId.isNotEmpty ? offer.jobId : collection.doc().id;
    final newOffer = offer.copyWith(jobId: id);

    await collection.doc(id).set(newOffer.toJson());

    await schoolCollection.doc(newOffer.schoolId).update({
      'jobPosts': FieldValue.arrayUnion([id]),
    });
  }

  @override
  Future<void> updateJobOffer(JobOfferModel jobOffer) async {
    final docRef = collection.doc(jobOffer.jobId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) throw Exception("Offre non trouvée");

    final oldOffer = JobOfferModel.fromJson(snapshot.data()!);
    await docRef.update(jobOffer.toJson());

    if (oldOffer.schoolId != jobOffer.schoolId) {
      await schoolCollection.doc(oldOffer.schoolId).update({
        'jobPosts': FieldValue.arrayRemove([jobOffer.jobId]),
      });

      await schoolCollection.doc(jobOffer.schoolId).update({
        'jobPosts': FieldValue.arrayUnion([jobOffer.jobId]),
      });
    }
  }

  @override
  Future<void> deleteJobOffer(String id) async {
    final docRef = collection.doc(id);
    final snapshot = await docRef.get();

    if (!snapshot.exists) throw Exception("Offre non trouvée");

    final offer = JobOfferModel.fromJson(snapshot.data()!);
    await docRef.delete();

    await schoolCollection.doc(offer.schoolId).update({
      'jobPosts': FieldValue.arrayRemove([id]),
    });
  }

  @override
  CollectionReference<Map<String, dynamic>> get collectionRef => collection;
}
