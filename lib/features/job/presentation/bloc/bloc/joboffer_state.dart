import 'package:equatable/equatable.dart';
import '../../../domain/models/joboffer_model.dart';

abstract class JobOfferState extends Equatable {
  const JobOfferState();

  @override
  List<Object?> get props => [];
}

class JobOfferInitial extends JobOfferState {}

class JobOfferLoading extends JobOfferState {}

class JobOfferLoaded extends JobOfferState {
  final List<JobOfferModel> offers;

  const JobOfferLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class JobOfferError extends JobOfferState {
  final String message;

  const JobOfferError(this.message);

  @override
  List<Object?> get props => [message];
}
