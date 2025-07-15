import 'package:gro_one_app/data/model/serializable.dart';

class AddConsigneeApiRequest extends Serializable<AddConsigneeApiRequest> {
  final String? name;
  final String? email;
  final String? mobileNumber;
  final String? loadId;

  AddConsigneeApiRequest({
    this.name,
    this.email,
    this.mobileNumber,
    this.loadId,
  });

  @override
  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (mobileNumber != null) 'mobileNumber': mobileNumber,
        if (loadId != null) 'loadId': loadId,
      };

  AddConsigneeApiRequest copyWith({
    String? name,
    String? email,
    String? mobileNumber,
    String? loadId,
  }) {
    return AddConsigneeApiRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      loadId: loadId ?? this.loadId,
    );
  }
}


class UpdateConsigneeApiRequest extends Serializable<UpdateConsigneeApiRequest> {
  final String? name;
  final String? email;
  final String? mobileNumber;

  UpdateConsigneeApiRequest({
    this.name,
    this.email,
    this.mobileNumber,
  });

  @override
  Map<String, dynamic> toJson() => {
    if (name != null && name!.isNotEmpty) 'name': name,
    if (email != null && email!.isNotEmpty) 'email': email,
    if (mobileNumber != null && mobileNumber!.isNotEmpty) 'mobileNumber': mobileNumber,
  };

  UpdateConsigneeApiRequest copyWith({
    String? name,
    String? email,
    String? mobileNumber,
  }) {
    return UpdateConsigneeApiRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}
