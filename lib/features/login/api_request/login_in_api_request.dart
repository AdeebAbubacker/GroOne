import 'package:gro_one_app/data/model/serializable.dart';

class LoginApiRequest implements Serializable<LoginApiRequest> {
  final int? mobile;
  final int? role;

  const LoginApiRequest({
    this.mobile,
    this.role,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile ?? 0,
      "role": role ?? 0,
    };
  }

  LoginApiRequest copyWith({
    int? mobile,
    int? role,
  }) {
    return LoginApiRequest(
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
    );
  }
}
