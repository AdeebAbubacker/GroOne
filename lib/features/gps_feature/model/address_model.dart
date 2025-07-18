// lib/features/gps_feature/model/address_model.dart
import 'package:equatable/equatable.dart';

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

  factory AddressPojo.fromTripReport(dynamic report) {
    return AddressPojo(
      id: report.startPositionId,  // CRITICAL FIX: Use start_position_id as unique trip identifier like Android
      deviceId: report.deviceId,   // Keep device ID for reference
      startLat: report.startLat,
      startLon: report.startLng,
      endLat: report.endLat,
      endLon: report.endLng,
    );
  }

  @override
  List<Object?> get props => [id, deviceId, startLat, startLon, endLat, endLon];
} 