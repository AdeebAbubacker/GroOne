part of 'reachability_cubit.dart';

class ReachabilityState extends Equatable {
  final bool isLoading;
  final bool isCreating;
  final bool isSuccess;
  final String? error;
  final List<GpsCombinedVehicleData> vehicles;
  final List<ReachabilityGeofence> geofences;
  final GpsCombinedVehicleData? selectedVehicle;
  final LocationMethod locationMethod;
  final String? locationAddress;
  final double? radius;
  final ReachabilityGeofence? selectedGeofence;
  final DateTime? selectedDate;
  final DateTime? selectedTime;
  final List<NotificationMethod> notificationMethods;
  final LatLng? mapCenter;

  const ReachabilityState({
    this.isLoading = false,
    this.isCreating = false,
    this.isSuccess = false,
    this.error,
    this.vehicles = const [],
    this.geofences = const [],
    this.selectedVehicle,
    this.locationMethod = LocationMethod.newLocation,
    this.locationAddress,
    this.radius,
    this.selectedGeofence,
    this.selectedDate,
    this.selectedTime,
    this.notificationMethods = const [],
    this.mapCenter,
  });

  ReachabilityState copyWith({
    bool? isLoading,
    bool? isCreating,
    bool? isSuccess,
    String? error,
    List<GpsCombinedVehicleData>? vehicles,
    List<ReachabilityGeofence>? geofences,
    GpsCombinedVehicleData? selectedVehicle,
    LocationMethod? locationMethod,
    String? locationAddress,
    double? radius,
    ReachabilityGeofence? selectedGeofence,
    DateTime? selectedDate,
    DateTime? selectedTime,
    List<NotificationMethod>? notificationMethods,
    LatLng? mapCenter,
  }) {
    return ReachabilityState(
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      vehicles: vehicles ?? this.vehicles,
      geofences: geofences ?? this.geofences,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      locationMethod: locationMethod ?? this.locationMethod,
      locationAddress: locationAddress ?? this.locationAddress,
      radius: radius ?? this.radius,
      selectedGeofence: selectedGeofence ?? this.selectedGeofence,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      notificationMethods: notificationMethods ?? this.notificationMethods,
      mapCenter: mapCenter ?? this.mapCenter,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isCreating,
    isSuccess,
    error,
    vehicles,
    geofences,
    selectedVehicle,
    locationMethod,
    locationAddress,
    radius,
    selectedGeofence,
    selectedDate,
    selectedTime,
    notificationMethods,
    mapCenter,
  ];
}
