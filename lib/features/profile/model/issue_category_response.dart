class IssueCategoryResponse {
    IssueCategoryResponse({
        required this.uuid,
        required this.issueCategory,
        required this.slug,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
    });

    final String uuid;
    final String issueCategory;
    final String slug;
    final bool isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    IssueCategoryResponse copyWith({
        String? uuid,
        String? issueCategory,
        String? slug,
        bool? isActive,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return IssueCategoryResponse(
            uuid: uuid ?? this.uuid,
            issueCategory: issueCategory ?? this.issueCategory,
            slug: slug ?? this.slug,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory IssueCategoryResponse.fromJson(Map<String, dynamic> json){ 
        return IssueCategoryResponse(
            uuid: json["uuid"] ?? "",
            issueCategory: json["issue_category"] ?? "",
            slug: json["slug"] ?? "",
            isActive: json["is_active"] ?? false,
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "issue_category": issueCategory,
        "slug": slug,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

}
