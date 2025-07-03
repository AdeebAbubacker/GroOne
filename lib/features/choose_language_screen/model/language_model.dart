class LanguageModel {
    LanguageModel({
        required this.id,
        required this.name,
        required this.languageText,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int id;
    final String name;
    final String languageText;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    LanguageModel copyWith({
        int? id,
        String? name,
        String? languageText,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return LanguageModel(
            id: id ?? this.id,
            name: name ?? this.name,
            languageText: languageText ?? this.languageText,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LanguageModel.fromJson(Map<String, dynamic> json){ 
        return LanguageModel(
            id: json["id"] ?? 0,
            name: json["name"] ?? "",
            languageText: json["languageText"] ?? "",
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "languageText": languageText,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };

}
