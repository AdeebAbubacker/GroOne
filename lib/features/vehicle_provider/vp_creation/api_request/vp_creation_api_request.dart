import 'package:gro_one_app/data/model/serializable.dart';

class VpCreationApiRequest implements Serializable<VpCreationApiRequest> {
  final String email;
  final String password;
  VpCreationApiRequest(this.password, {required this.email});

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email.trim(),
      "password": password.trim(),
    };
  }

}