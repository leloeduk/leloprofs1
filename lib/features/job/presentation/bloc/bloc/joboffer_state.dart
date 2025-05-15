import 'package:equatable/equatable.dart';
import 'package:leloprof/features/job/data/models/joboffer_model.dart';

abstract class JobOfferState extends Equatable {
  const JobOfferState();

  @override
  List<Object?> get props => [];
}

class JobOfferInitial extends JobOfferState {}

class JobOfferLoading extends JobOfferState {}

class JobOfferLoaded extends JobOfferState {
  final List<JobOfferModel> jobOffers;

  const JobOfferLoaded(this.jobOffers);

  @override
  List<Object?> get props => [jobOffers];
}

class JobOfferError extends JobOfferState {
  final String message;

  const JobOfferError(this.message);

  @override
  List<Object?> get props => [message];
}
