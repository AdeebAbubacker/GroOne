class AppUpdateResponse {
  AppUpdateResponse({
    required this.updateRequired,
    required this.isForce,
    required this.version,
  });

  final bool updateRequired;
  final bool isForce;
  final String version;

  AppUpdateResponse copyWith({
    bool? updateRequired,
    bool? isForce,
    String? version,
  }) {
    return AppUpdateResponse(
      updateRequired: updateRequired ?? this.updateRequired,
      isForce: isForce ?? this.isForce,
      version: version ?? this.version,
    );
  }

  factory AppUpdateResponse.fromJson(Map<String, dynamic> json){
    return AppUpdateResponse(
      updateRequired: json["updateRequired"] ?? false,
      isForce: json["isForce"] ?? false,
      version: json["version"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "updateRequired": updateRequired,
    "isForce": isForce,
    "version": version,
  };

}
