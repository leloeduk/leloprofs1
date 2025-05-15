import 'package:equatable/equatable.dart';

enum SubscriptionType { free, vip, premium }

SubscriptionType subscriptionTypeFromString(String type) {
  switch (type.toLowerCase()) {
    case 'vip':
      return SubscriptionType.vip;
    case 'premium':
      return SubscriptionType.premium;
    default:
      return SubscriptionType.free;
  }
}

String subscriptionTypeToString(SubscriptionType type) {
  return type.name;
}

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

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      userId: map['userId'] as String,
      type: subscriptionTypeFromString(map['type'] as String),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': subscriptionTypeToString(type),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [userId, type, startDate, endDate];
}
