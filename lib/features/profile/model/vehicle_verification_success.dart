class VehicleVerificationSuccess {
    VehicleVerificationSuccess({
        required this.message,
        required this.data,
    });

    final String message;
    final bool data;

    VehicleVerificationSuccess copyWith({
        String? message,
        bool? data,
    }) {
        return VehicleVerificationSuccess(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory VehicleVerificationSuccess.fromJson(Map<String, dynamic> json){ 
        return VehicleVerificationSuccess(
            message: json["message"] ?? "",
            data: json["data"] ?? false,
        );
    }

}
