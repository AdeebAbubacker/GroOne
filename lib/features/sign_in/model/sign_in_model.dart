class SignInModel {
  final bool status;
  final String message;
  final SignInData? data;

  SignInModel({
    required this.status,
    required this.message,
    this.data,
  });

  SignInModel copyWith({
    bool? status,
    String? message,
    SignInData? data,
  }) {
    return SignInModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
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
