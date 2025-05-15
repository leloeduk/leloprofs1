import 'package:equatable/equatable.dart';
import 'package:leloprof/features/job/data/models/joboffer_model.dart';

abstract class JobOfferEvent extends Equatable {
  const JobOfferEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobOffers extends JobOfferEvent {}

class CreateJobOffer extends JobOfferEvent {
  final JobOfferModel jobOffer;

  const CreateJobOffer(this.jobOffer);

  @override
  List<Object?> get props => [jobOffer];
}

class UpdateJobOffer extends JobOfferEvent {
  final JobOfferModel jobOffer;

  const UpdateJobOffer(this.jobOffer);

  @override
  List<Object?> get props => [jobOffer];
}

class DeleteJobOffer extends JobOfferEvent {
  final String id;

  const DeleteJobOffer(this.id);

  @override
  List<Object?> get props => [id];
}
