class GpsParkingModeModel {
  final int id;
  final int deviceId;
  final bool parkingMode;

  GpsParkingModeModel({
    required this.id,
    required this.deviceId,
    required this.parkingMode,
  });

  factory GpsParkingModeModel.fromJson(Map<String, dynamic> json) {
    return GpsParkingModeModel(
      id: json['id'],
      deviceId: json['device_id'],
      parkingMode: json['parking_mode'] ?? false,
    );
  }
}
