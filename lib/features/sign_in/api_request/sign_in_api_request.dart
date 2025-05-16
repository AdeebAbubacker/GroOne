import 'package:gro_one_app/data/model/serializable.dart';

class SignInApiRequest implements Serializable<SignInApiRequest> {
  final String email;
  final String password;
  SignInApiRequest(this.password, {required this.email});

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email.trim(),
      "password": password.trim(),
    };
  }

}