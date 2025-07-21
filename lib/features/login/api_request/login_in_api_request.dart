import 'package:gro_one_app/data/model/serializable.dart';

class LoginApiRequest implements Serializable<LoginApiRequest> {
  final int? mobile;
  final int? type;

  const LoginApiRequest({
    this.mobile,
    this.type,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile ?? 0,
      "type": type ?? 0,
    };
  }

  LoginApiRequest copyWith({
    int? mobile,
    int? type,
  }) {
    return LoginApiRequest(
      mobile: mobile ?? this.mobile,
      type: type ?? this.type,
    );
  }
}
