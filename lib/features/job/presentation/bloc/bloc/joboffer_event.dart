import 'package:equatable/equatable.dart';
import '../../../domain/models/joboffer_model.dart';

abstract class JobOfferEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadJobOffers extends JobOfferEvent {
  final String? schoolId;

  LoadJobOffers([this.schoolId]);

  @override
  List<Object?> get props => [schoolId];
}

class CreateJobOffer extends JobOfferEvent {
  final JobOfferModel jobOffer;

  CreateJobOffer(this.jobOffer);

  @override
  List<Object?> get props => [jobOffer];
}

class UpdateJobOffer extends JobOfferEvent {
  final JobOfferModel jobOffer;

  UpdateJobOffer(this.jobOffer);

  @override
  List<Object?> get props => [jobOffer];
}

class DeleteJobOffer extends JobOfferEvent {
  final String jobId;
  final String schoolId;

  DeleteJobOffer({required this.jobId, required this.schoolId});

  @override
  List<Object?> get props => [jobId, schoolId];
}
