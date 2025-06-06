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

  DeleteJobOffer({required this.jobId});

  @override
  List<Object?> get props => [jobId];
}

class ApplyForJob extends JobOfferEvent {
  final String jobOfferId;

  ApplyForJob({required this.jobOfferId});

  @override
  List<Object> get props => [jobOfferId];
}
