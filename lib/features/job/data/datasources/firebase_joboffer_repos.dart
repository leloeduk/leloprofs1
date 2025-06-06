import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (schoolId != null) {
        snapshot =
            await collection
                .where('schoolId', isEqualTo: schoolId)
                .orderBy('createdAt', descending: true)
                .get();
      } else {
        snapshot =
            await collection.orderBy('createdAt', descending: true).get();
      }

      // Ajoutez des logs pour vérifier les documents retournés
      print('Number of documents retrieved: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Document data: ${doc.data()}');
      }

      return snapshot.docs
          .map((doc) => JobOfferModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Erreur lors du chargement des offres : $e");
      return [];
    }
  }

  @override
  Future<JobOfferModel?> getJobOfferById(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (doc.exists) {
        return JobOfferModel.fromJson(doc.data()!);
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'offre : $e");
    }
    return null;
  }

  @override
  Future<void> createJobOffer(JobOfferModel newOffer) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('jobOffers');
    final id = collection.doc().id;

    final schoolCollection = firestore.collection('schools');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(collection.doc(id), {
        ...newOffer.toJson(),
        'createdAt': FieldValue.serverTimestamp(), // ✅ Corrigé ici
      });

      transaction.update(schoolCollection.doc(newOffer.schoolId), {
        'jobPosts': FieldValue.arrayUnion([id]),
      });
    });
  }

  @override
  Future<bool> updateJobOffer(JobOfferModel jobOffer) async {
    try {
      final docRef = collection.doc(jobOffer.jobId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) throw Exception("Offre non trouvée");

      final oldOffer = JobOfferModel.fromJson(snapshot.data()!);

      await docRef.update(jobOffer.toJson());

      if (oldOffer.schoolId != jobOffer.schoolId) {
        // Transfert entre écoles
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(schoolCollection.doc(oldOffer.schoolId), {
            'jobPosts': FieldValue.arrayRemove([jobOffer.jobId]),
          });

          transaction.update(schoolCollection.doc(jobOffer.schoolId), {
            'jobPosts': FieldValue.arrayUnion([jobOffer.jobId]),
          });
        });
      }

      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour de l'offre : $e");
      return false;
    }
  }

  @override
  Future<bool> deleteJobOffer(String id) async {
    try {
      final docRef = collection.doc(id);
      final snapshot = await docRef.get();

      if (!snapshot.exists) throw Exception("Offre non trouvée");

      final offer = JobOfferModel.fromJson(snapshot.data()!);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(docRef);
        transaction.update(schoolCollection.doc(offer.schoolId), {
          'jobPosts': FieldValue.arrayRemove([id]),
        });
      });

      return true;
    } catch (e) {
      print("Erreur lors de la suppression de l'offre : $e");
      return false;
    }
  }

  @override
  Future<void> applyForJob(String jobOfferId) async {
    try {
      // Implémentez la logique Firebase pour enregistrer la candidature
      await FirebaseFirestore.instance.collection('jobApplications').add({
        'jobOfferId': jobOfferId,
        'applicantId': FirebaseAuth.instance.currentUser?.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Erreur lors de la candidature : $e");
      throw Exception("Erreur lors de la candidature");
    }
  }

  @override
  CollectionReference<Map<String, dynamic>> get collectionRef => collection;
}
