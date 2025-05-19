import 'package:equatable/equatable.dart';

import '../../../domain/models/joboffer_model.dart';

abstract class JobOfferState extends Equatable {
  const JobOfferState();
}

class JobOfferInitial extends JobOfferState {
  @override
  List<Object?> get props => [];
}

class JobOfferLoading extends JobOfferState {
  @override
  List<Object?> get props => [];
}

class JobOffersLoaded extends JobOfferState {
  final List<JobOfferModel> offers;
  const JobOffersLoaded(this.offers);
  @override
  List<Object?> get props => [offers];
}

class JobOfferOperationSuccess extends JobOfferState {
  final String message;
  const JobOfferOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class JobOfferError extends JobOfferState {
  final String message;
  const JobOfferError(this.message);
  @override
  List<Object?> get props => [message];
}
