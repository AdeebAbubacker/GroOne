class ConsigneAddedSuccessModel {
    ConsigneAddedSuccessModel({
        required this.name,
        required this.email,
        required this.mobileNumber,
        required this.loadId,
        required this.id,
    });

    final String name;
    final String email;
    final String mobileNumber;
    final String loadId;
    final String id;

    ConsigneAddedSuccessModel copyWith({
        String? name,
        String? email,
        String? mobileNumber,
        String? loadId,
        String? id,
    }) {
        return ConsigneAddedSuccessModel(
            name: name ?? this.name,
            email: email ?? this.email,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            loadId: loadId ?? this.loadId,
            id: id ?? this.id,
        );
    }

    factory ConsigneAddedSuccessModel.fromJson(Map<String, dynamic> json){ 
        return ConsigneAddedSuccessModel(
            name: json["name"] ?? "",
            email: json["email"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            loadId: json["loadId"] ?? "",
            id: json["id"] ?? "",
        );
    }

}
