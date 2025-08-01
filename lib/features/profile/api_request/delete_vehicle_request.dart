class DeleteVehicleRequest {
  DeleteVehicleRequest({
    required this.status,
  });

  final int status;

  Map<String, dynamic> toJson() => {
    "status": status,
  };

}
