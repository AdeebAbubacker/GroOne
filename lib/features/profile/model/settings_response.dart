class SettingsResponse {
  SettingsResponse({
    required this.id,
    required this.key,
    required this.label,
    required this.type,
    required this.defaultValue,
    required this.options,
    required this.section,
  });

  final int id;
  final String key;
  final String label;
  final String type;
  final String defaultValue;
  final String options;
  final String section;

  SettingsResponse copyWith({
    int? id,
    String? key,
    String? label,
    String? type,
    String? defaultValue,
    String? options,
    String? section,
  }) {
    return SettingsResponse(
      id: id ?? this.id,
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      defaultValue: defaultValue ?? this.defaultValue,
      options: options ?? this.options,
      section: section ?? this.section,
    );
  }

  factory SettingsResponse.fromJson(Map<String, dynamic> json){
    return SettingsResponse(
      id: json["id"] ?? 0,
      key: json["key"] ?? "",
      label: json["label"] ?? "",
      type: json["type"] ?? "",
      defaultValue: json["defaultValue"] ?? "",
      options: json["options"] ?? "",
      section: json["section"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "label": label,
    "type": type,
    "defaultValue": defaultValue,
    "options": options,
    "section": section,
  };

}
