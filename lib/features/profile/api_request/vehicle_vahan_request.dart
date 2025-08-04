class VehicleVahanRequest {
  VehicleVahanRequest({
    required this.vehicleNumber,
  });

  final String vehicleNumber;


  Map<String, dynamic> toJson() => {
        "vehicle_number": vehicleNumber,
      };
}
