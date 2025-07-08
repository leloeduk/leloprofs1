import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_application_event.dart';
import 'teacher_application_state.dart';

class TeacherApplicationBloc
    extends Bloc<TeacherApplicationEvent, TeacherApplicationState> {
  final FirebaseFirestore firestore;

  TeacherApplicationBloc({required this.firestore})
    : super(TeacherApplicationInitial()) {
    on<ApplyToJobOffer>(_onApplyToJobOffer);
  }

  Future<void> _onApplyToJobOffer(
    ApplyToJobOffer event,
    Emitter<TeacherApplicationState> emit,
  ) async {
    emit(TeacherApplicationLoading());

    try {
      final applicationData = {
        ...event.teacherData.toMap(),
        'appliedAt': Timestamp.now(),
        'status': 'pending', // Ajout d'un statut par défaut
      };

      // Référence à la collection des candidatures
      final applicationRef = firestore
          .collection('jobOffers')
          .doc(event.jobId)
          .collection('applications')
          .doc(event.teacherData.teacherId);

      // Vérifier si l'enseignant a déjà postulé
      final existingApplication = await applicationRef.get();

      if (existingApplication.exists) {
        emit(
          const TeacherApplicationError('Vous avez déjà postulé à cette offre'),
        );
        return;
      }

      await applicationRef.set(applicationData);

      // Mettre à jour le compteur de candidatures sur l'offre
      await firestore.collection('jobOffers').doc(event.jobId).update({
        'applicationCount': FieldValue.increment(1),
      });

      emit(TeacherApplicationSuccess());
    } catch (e) {
      emit(TeacherApplicationError('Échec de la candidature: ${e.toString()}'));
    }
  }
}
