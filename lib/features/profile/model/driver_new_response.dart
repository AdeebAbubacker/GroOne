class DriverNewModel {
    DriverNewModel({
        required this.message,
        required this.data,
    });

    final String message;
    final Data? data;

    DriverNewModel copyWith({
        String? message,
        Data? data,
    }) {
        return DriverNewModel(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory DriverNewModel.fromJson(Map<String, dynamic> json){ 
        return DriverNewModel(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.driverId,
        required this.name,
        required this.mobile,
        required this.email,
        required this.customerId,
    });

    final String driverId;
    final String name;
    final String mobile;
    final String email;
    final String customerId;

    Data copyWith({
        String? driverId,
        String? name,
        String? mobile,
        String? email,
        String? customerId,
    }) {
        return Data(
            driverId: driverId ?? this.driverId,
            name: name ?? this.name,
            mobile: mobile ?? this.mobile,
            email: email ?? this.email,
            customerId: customerId ?? this.customerId,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            driverId: json["driverId"] ?? "",
            name: json["name"] ?? "",
            mobile: json["mobile"] ?? "",
            email: json["email"] ?? "",
            customerId: json["customerId"] ?? "",
        );
    }

}
