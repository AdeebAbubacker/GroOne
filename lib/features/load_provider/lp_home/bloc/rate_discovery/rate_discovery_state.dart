part of 'rate_discovery_bloc.dart';

@immutable
sealed class RateDiscoveryState {}

class RateDiscoveryInitial extends RateDiscoveryState {}

class RateDiscoveryLoading extends RateDiscoveryState {}

class RateDiscoverySuccess extends RateDiscoveryState {
  final RateDiscoveryModel rateDiscoveryModel;
  RateDiscoverySuccess(this.rateDiscoveryModel);
}

class RateDiscoveryError extends RateDiscoveryState {
  final ErrorType errorType;
  RateDiscoveryError(this.errorType);
}
