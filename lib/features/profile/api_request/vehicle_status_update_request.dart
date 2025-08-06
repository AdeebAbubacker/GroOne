class VehicleStatusUpdateRequest {
  VehicleStatusUpdateRequest({
    required this.status,
  });

  final int status;


  factory VehicleStatusUpdateRequest.fromJson(Map<String, dynamic> json){
    return VehicleStatusUpdateRequest(
      status: json["status"] ?? 1,

    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
  };

}
