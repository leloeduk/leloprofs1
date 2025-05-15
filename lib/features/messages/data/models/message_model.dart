import 'package:equatable/equatable.dart';

enum SubscriptionType { free, vip, premium }

class Subscription extends Equatable {
  final String userId;
  final SubscriptionType type;
  final DateTime startDate;
  final DateTime endDate;

  const Subscription({
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  bool get isActive => endDate.isAfter(DateTime.now());

  @override
  List<Object?> get props => [userId, type, startDate, endDate];
}
