class PrivacyDetailsModel {
    PrivacyDetailsModel({
        required this.message,
        required this.data,
    });

    final String? message;
    final List<PrivacyPolicyDetails> data;

    PrivacyDetailsModel copyWith({
        String? message,
        List<PrivacyPolicyDetails>? data,
    }) {
        return PrivacyDetailsModel(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory PrivacyDetailsModel.fromJson(Map<String, dynamic> json){ 
        return PrivacyDetailsModel(
            message: json["message"],
            data: json["data"] == null ? [] : List<PrivacyPolicyDetails>.from(json["data"]!.map((x) => PrivacyPolicyDetails.fromJson(x))),
        );
    }

}

class PrivacyPolicyDetails {
    PrivacyPolicyDetails({
        required this.id,
        required this.title,
        required this.content,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int? id;
    final String? title;
    final String? content;
    final int? status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    PrivacyPolicyDetails copyWith({
        int? id,
        String? title,
        String? content,
        int? status,
        DateTime? createdAt,
        dynamic deletedAt,
    }) {
        return PrivacyPolicyDetails(
            id: id ?? this.id,
            title: title ?? this.title,
            content: content ?? this.content,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory PrivacyPolicyDetails.fromJson(Map<String, dynamic> json){ 
        return PrivacyPolicyDetails(
            id: json["id"],
            title: json["title"],
            content: json["content"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }
}
