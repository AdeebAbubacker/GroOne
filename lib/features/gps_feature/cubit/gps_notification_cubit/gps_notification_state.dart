part of 'gps_notification_cubit.dart';

abstract class GpsNotificationState extends Equatable {
  const GpsNotificationState();
  @override
  List<Object?> get props => [];
}

class GpsNotificationInitial extends GpsNotificationState {}

class GpsNotificationLoading extends GpsNotificationState {}

class GpsNotificationLoaded extends GpsNotificationState {
  final List<GpsNotificationModel> notifications;
  const GpsNotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class GpsNotificationError extends GpsNotificationState {
  final String message;
  const GpsNotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
