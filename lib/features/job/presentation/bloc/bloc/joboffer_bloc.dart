import 'package:bloc/bloc.dart';

import '../../../domain/repositories/joboffer_repository.dart';
import 'joboffer_event.dart';
import 'joboffer_state.dart';

class JobOfferBloc extends Bloc<JobOfferEvent, JobOfferState> {
  final JobOfferRepository jobOfferRepository;

  JobOfferBloc({required this.jobOfferRepository}) : super(JobOfferInitial()) {
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
      final jobOffers = await jobOfferRepository.fetchAllJobOffers();
      emit(JobOffersLoaded(jobOffers));
    } catch (e) {
      emit(
        JobOfferError('Erreur lors du chargement des offres : ${e.toString()}'),
      );
    }
  }

  Future<void> _onCreateJobOffer(
    CreateJobOffer event,
    Emitter<JobOfferState> emit,
  ) async {
    emit(JobOfferLoading());
    try {
      await jobOfferRepository.createJobOffer(event.offer);
      final jobOffers = await jobOfferRepository.fetchAllJobOffers();
      emit(JobOffersLoaded(jobOffers));
    } catch (e) {
      emit(
        JobOfferError(
          'Erreur lors de la création de l\'offre : ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateJobOffer(
    UpdateJobOffer event,
    Emitter<JobOfferState> emit,
  ) async {
    emit(JobOfferLoading());
    try {
      await jobOfferRepository.updateJobOffer(event.offer);
      final jobOffers = await jobOfferRepository.fetchAllJobOffers();
      emit(JobOffersLoaded(jobOffers));
    } catch (e) {
      emit(
        JobOfferError(
          'Erreur lors de la mise à jour de l\'offre : ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteJobOffer(
    DeleteJobOffer event,
    Emitter<JobOfferState> emit,
  ) async {
    emit(JobOfferLoading());
    try {
      await jobOfferRepository.deleteJobOffer(event.offerId);
      final jobOffers = await jobOfferRepository.fetchAllJobOffers();
      emit(JobOffersLoaded(jobOffers));
    } catch (e) {
      emit(
        JobOfferError(
          'Erreur lors de la suppression de l\'offre : ${e.toString()}',
        ),
      );
    }
  }
}
