import 'package:flutter_bloc/flutter_bloc.dart';
import 'joboffer_event.dart';
import 'joboffer_state.dart';
import '../../../domain/models/joboffer_model.dart';
import '../../../domain/repositories/joboffer_repository.dart';

class JobOfferBloc extends Bloc<JobOfferEvent, JobOfferState> {
  final JobOfferRepository repository;

  JobOfferBloc(this.repository) : super(JobOfferInitial()) {
    on<LoadJobOffers>(_onLoadJobOffers);
    on<CreateJobOffer>(_onCreateJobOffer);
    on<UpdateJobOffer>(_onUpdateJobOffer);
    on<DeleteJobOffer>(_onDeleteJobOffer);
  }

  Future<void> _onLoadJobOffers(
    LoadJobOffers event,
    Emitter<JobOfferState> emit,
  ) async {
    emit(JobOfferLoading());

    try {
      // Charge les offres, filtrées par schoolId si elle est fournie
      final offers = await repository.fetchAllJobOffers(event.schoolId);
      emit(JobOfferLoaded(offers));
    } catch (e) {
      emit(JobOfferError("Erreur lors du chargement : $e"));
    }
  }

  Future<void> _onCreateJobOffer(
    CreateJobOffer event,
    Emitter<JobOfferState> emit,
  ) async {
    try {
      await repository.createJobOffer(event.jobOffer);
      add(LoadJobOffers());
    } catch (e) {
      emit(JobOfferError("Erreur lors de la création : $e"));
    }
  }

  Future<void> _onUpdateJobOffer(
    UpdateJobOffer event,
    Emitter<JobOfferState> emit,
  ) async {
    try {
      await repository.updateJobOffer(event.jobOffer);
      add(LoadJobOffers());
    } catch (e) {
      emit(JobOfferError("Erreur lors de la mise à jour : $e"));
    }
  }

  Future<void> _onDeleteJobOffer(
    DeleteJobOffer event,
    Emitter<JobOfferState> emit,
  ) async {
    try {
      await repository.deleteJobOffer(event.jobId);
      add(LoadJobOffers());
    } catch (e) {
      emit(JobOfferError("Erreur lors de la suppression : $e"));
    }
  }
}
