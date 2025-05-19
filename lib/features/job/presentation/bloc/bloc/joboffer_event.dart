import 'package:equatable/equatable.dart';

import '../../../domain/models/joboffer_model.dart';

abstract class JobOfferEvent extends Equatable {
  const JobOfferEvent();
}

class LoadJobOffers extends JobOfferEvent {
  final String schoolId;
  const LoadJobOffers(this.schoolId, {required String schoolUid});
  @override
  List<Object?> get props => [schoolId];
}

class CreateJobOffer extends JobOfferEvent {
  final JobOfferModel offer;
  const CreateJobOffer(this.offer);
  @override
  List<Object?> get props => [offer];
}

class UpdateJobOffer extends JobOfferEvent {
  final JobOfferModel offer;
  const UpdateJobOffer(this.offer);
  @override
  List<Object?> get props => [offer];
}

class ToggleJobOfferStatus extends JobOfferEvent {
  final String offerId;
  final bool isActive;
  const ToggleJobOfferStatus(this.offerId, this.isActive);
  @override
  List<Object?> get props => [offerId, isActive];
}

class DeleteJobOffer extends JobOfferEvent {
  final String offerId;
  const DeleteJobOffer(this.offerId);
  @override
  List<Object?> get props => [offerId];
}
