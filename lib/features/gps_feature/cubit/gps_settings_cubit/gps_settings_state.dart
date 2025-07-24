abstract class GpsSettingsState {}

class GpsSettingsInitial extends GpsSettingsState {}

class GpsSettingsLoading extends GpsSettingsState {}

class GpsSettingsSuccess extends GpsSettingsState {
  final bool isEnabled;
  GpsSettingsSuccess(this.isEnabled);
}

class GpsSettingsError extends GpsSettingsState {
  final String message;
  GpsSettingsError(this.message);
}
