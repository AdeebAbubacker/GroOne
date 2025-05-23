class VpCreationModel {
  final bool status;
  final String message;
  final SignInData? data;

  VpCreationModel({
    required this.status,
    required this.message,
    this.data,
  });

  VpCreationModel copyWith({
    bool? status,
    String? message,
    SignInData? data,
  }) {
    return VpCreationModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory VpCreationModel.fromJson(Map<String, dynamic> json) {
    return VpCreationModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? SignInData.fromJson(json["data"]) : null,
    );
  }
}

class SignInData {
  final String token;
  final String userId;
  final String name;
  final String email;

  SignInData({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
  });

  SignInData copyWith({
    String? token,
    String? userId,
    String? name,
    String? email,
  }) {
    return SignInData(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory SignInData.fromJson(Map<String, dynamic> json) {
    return SignInData(
      token: json["token"] ?? "",
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}
