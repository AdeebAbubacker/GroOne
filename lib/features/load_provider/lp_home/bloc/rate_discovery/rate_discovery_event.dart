part of 'rate_discovery_bloc.dart';

@immutable
class RateDiscoveryEvent {
  final RateDiscoveryApiRequest apiRequest;
  const RateDiscoveryEvent({required this.apiRequest});
}

// /// Create Load Post
// class CreateLoadPostingEvent extends LoadPostingEvent {
//   final RateDiscoveryApiRequest apiRequest;
//   CreateLoadPostingEvent({required this.apiRequest});
// }

