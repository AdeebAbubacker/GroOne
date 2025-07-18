// lib/features/gps_feature/model/address_model.dart
import 'package:equatable/equatable.dart';
import 'report_model.dart';

class AddressRequest extends Equatable {
  final int id;
  final String lat;
  final String lng;

  const AddressRequest({
    required this.id,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
    };
  }

  @override
  List<Object?> get props => [id, lat, lng];
}

class AddressResponse extends Equatable {
  final int positionId; // This should be the trip ID (start_position_id)
  final int deviceId;   // Keep device ID for reference
  final String startAddress;
  final String endAddress;

  const AddressResponse({
    required this.positionId,
    required this.deviceId,
    required this.startAddress,
    required this.endAddress,
  });

  @override
  List<Object?> get props => [positionId, deviceId, startAddress, endAddress];
}

// New model for stop addresses
class StopAddressResponse extends Equatable {
  final String stopId;    // Unique ID for the stop (deviceId + startTime)
  final int deviceId;     // Device ID for reference
  final String address;   // Single address for the stop location

  const StopAddressResponse({
    required this.stopId,
    required this.deviceId,
    required this.address,
  });

  @override
  List<Object?> get props => [stopId, deviceId, address];
}

class AddressPojo extends Equatable {
  final int id;         // This should be the trip ID (start_position_id)
  final int deviceId;   // Device ID for reference
  final double startLat;
  final double startLon;
  final double endLat;
  final double endLon;

  const AddressPojo({
    required this.id,
    required this.deviceId,
    required this.startLat,
    required this.startLon,
    required this.endLat,
    required this.endLon,
  });

  factory AddressPojo.fromTripReport(TripReport report) {
    return AddressPojo(
      id: report.startPositionId, // Use trip ID instead of device ID
      deviceId: report.deviceId,  // Keep device ID for reference
      startLat: report.startLat,
      startLon: report.startLng,
      endLat: report.endLat,
      endLon: report.endLng,
    );
  }

  @override
  List<Object?> get props => [id, deviceId, startLat, startLon, endLat, endLon];
}

// New model for stop address requests
class StopAddressPojo extends Equatable {
  final String stopId;    // Unique ID for the stop (deviceId + startTime)
  final int deviceId;     // Device ID for reference
  final double latitude;
  final double longitude;

  const StopAddressPojo({
    required this.stopId,
    required this.deviceId,
    required this.latitude,
    required this.longitude,
  });

  factory StopAddressPojo.fromStopReport(StopReport report) {
    // Create unique stop ID using device ID and start time
    final stopId = "${report.deviceId}_${report.startTime}";
    return StopAddressPojo(
      stopId: stopId,
      deviceId: report.deviceId,
      latitude: report.latitude,
      longitude: report.longitude,
    );
  }

  @override
  List<Object?> get props => [stopId, deviceId, latitude, longitude];
}

class SummaryAddressResponse extends Equatable {
  final String summaryId; // Unique identifier for this summary (deviceId_startTime)
  final int deviceId;
  final String startAddress;
  final String endAddress;

  const SummaryAddressResponse({
    required this.summaryId,
    required this.deviceId,
    required this.startAddress,
    required this.endAddress,
  });

  @override
  List<Object?> get props => [summaryId, deviceId, startAddress, endAddress];
}

class SummaryAddressPojo extends Equatable {
  final String summaryId; // Unique identifier for this summary (deviceId_startTime)
  final int deviceId;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  const SummaryAddressPojo({
    required this.summaryId,
    required this.deviceId,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  factory SummaryAddressPojo.fromSummaryReport(SummaryReport report) {
    // Create unique summary ID using device ID and start time
    final summaryId = "${report.deviceId}_${report.startTime}";
    
    return SummaryAddressPojo(
      summaryId: summaryId,
      deviceId: report.deviceId,
      startLat: report.startLat,
      startLng: report.startLng,
      endLat: report.endLat,
      endLng: report.endLng,
    );
  }

  @override
  List<Object?> get props => [summaryId, deviceId, startLat, startLng, endLat, endLng];
} 