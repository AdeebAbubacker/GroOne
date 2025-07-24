abstract class GpsNotificationTypesSheetState {}

class GpsNotificationTypesInitial extends GpsNotificationTypesSheetState {}

class GpsNotificationTypesLoading extends GpsNotificationTypesSheetState {}

class GpsNotificationTypesLoaded extends GpsNotificationTypesSheetState {
  final Map<String, bool> toggles;

  GpsNotificationTypesLoaded(this.toggles);
}

class GpsNotificationTypesError extends GpsNotificationTypesSheetState {
  final String message;

  GpsNotificationTypesError(this.message);
}
