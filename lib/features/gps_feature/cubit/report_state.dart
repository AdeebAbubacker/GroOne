// lib/features/gps_feature/cubit/report_state.dart
part of 'report_cubit.dart'; // This will connect it to the Cubit file we create next

// Enum to represent the different loading states for data
enum GpsDataStatus { initial, loading, success, error }

// Enum to represent the different types of reports the user can select
enum ReportType {
  stops('STOPS'),
  trips('TRIPS'),
  daily('DAILY'),
  dailyKm('DAILY KM'),
  reachability('REACHABILITY');

  const ReportType(this.displayName);
  final String displayName;
}

class GpsReportState extends Equatable {
  // State for the vehicle dropdown
  final GpsDataStatus vehicleStatus;
  final List<GpsCombinedVehicleData> vehicles;

  // State for the report list itself
  final GpsDataStatus reportStatus;
  final List<dynamic> reports; // This list can hold any type of report model
  final ReportType?
  currentReportType; // To know what kind of data is in the list

  // State for trip addresses
  final GpsDataStatus addressStatus;
  final Map<int, AddressResponse> addresses; // Trip ID -> Address mapping

  // State for stop addresses
  final GpsDataStatus stopAddressStatus;
  final Map<String, StopAddressResponse> stopAddresses; // Stop ID -> Address mapping

  // State for summary addresses
  final GpsDataStatus summaryAddressStatus;
  final Map<String, SummaryAddressResponse> summaryAddresses; // Summary ID -> Address mapping

  // General error message for the screen
  final String? errorMessage;

  const GpsReportState({
    this.vehicleStatus = GpsDataStatus.initial,
    this.vehicles = const [],
    this.reportStatus = GpsDataStatus.initial,
    this.reports = const [],
    this.currentReportType,
    this.addressStatus = GpsDataStatus.initial,
    this.addresses = const {},
    this.stopAddressStatus = GpsDataStatus.initial,
    this.stopAddresses = const {},
    this.summaryAddressStatus = GpsDataStatus.initial,
    this.summaryAddresses = const {},
    this.errorMessage,
  });

  // copyWith allows us to create a new state object based on the old one,
  // making state updates easy and predictable.
  GpsReportState copyWith({
    GpsDataStatus? vehicleStatus,
    List<GpsCombinedVehicleData>? vehicles,
    GpsDataStatus? reportStatus,
    List<dynamic>? reports,
    ReportType? currentReportType,
    GpsDataStatus? addressStatus,
    Map<int, AddressResponse>? addresses,
    GpsDataStatus? stopAddressStatus,
    Map<String, StopAddressResponse>? stopAddresses,
    GpsDataStatus? summaryAddressStatus,
    Map<String, SummaryAddressResponse>? summaryAddresses,
    String? errorMessage,
  }) {
    return GpsReportState(
      vehicleStatus: vehicleStatus ?? this.vehicleStatus,
      vehicles: vehicles ?? this.vehicles,
      reportStatus: reportStatus ?? this.reportStatus,
      reports: reports ?? this.reports,
      currentReportType: currentReportType ?? this.currentReportType,
      addressStatus: addressStatus ?? this.addressStatus,
      addresses: addresses ?? this.addresses,
      stopAddressStatus: stopAddressStatus ?? this.stopAddressStatus,
      stopAddresses: stopAddresses ?? this.stopAddresses,
      summaryAddressStatus: summaryAddressStatus ?? this.summaryAddressStatus,
      summaryAddresses: summaryAddresses ?? this.summaryAddresses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        vehicleStatus,
        vehicles,
        reportStatus,
        reports,
        currentReportType,
        addressStatus,
        addresses,
        stopAddressStatus,
        stopAddresses,
        summaryAddressStatus,
        summaryAddresses,
        errorMessage,
      ];
}