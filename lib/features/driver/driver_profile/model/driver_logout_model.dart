class DriverlogoutModel {
    DriverlogoutModel({
        required this.message,
    });

    final String message;

    DriverlogoutModel copyWith({
        String? message,
    }) {
        return DriverlogoutModel(
            message: message ?? this.message,
        );
    }

    factory DriverlogoutModel.fromJson(Map<String, dynamic> json){ 
        return DriverlogoutModel(
            message: json["message"] ?? "",
        );
    }

}
