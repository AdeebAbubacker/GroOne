class TermsAndconditionsModel {
    TermsAndconditionsModel({
        required this.message,
        required this.data,
    });

    final String? message;
    final List<TermsAndConditionsDetails> data;

    TermsAndconditionsModel copyWith({
        String? message,
        List<TermsAndConditionsDetails>? data,
    }) {
        return TermsAndconditionsModel(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory TermsAndconditionsModel.fromJson(Map<String, dynamic> json){ 
        return TermsAndconditionsModel(
            message: json["message"],
            data: json["data"] == null ? [] : List<TermsAndConditionsDetails>.from(json["data"]!.map((x) => TermsAndConditionsDetails.fromJson(x))),
        );
    }

}

class TermsAndConditionsDetails {
    TermsAndConditionsDetails({
        required this.id,
        required this.sectionIdentifier,
        required this.sectionTitle,
        required this.content,
        required this.parentId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final int? id;
    final String? sectionIdentifier;
    final String? sectionTitle;
    final String? content;
    final int? parentId;
    final int? status;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    TermsAndConditionsDetails copyWith({
        int? id,
        String? sectionIdentifier,
        String? sectionTitle,
        String? content,
        int? parentId,
        int? status,
        DateTime? createdAt,
        dynamic updatedAt,
        dynamic deletedAt,
    }) {
        return TermsAndConditionsDetails(
            id: id ?? this.id,
            sectionIdentifier: sectionIdentifier ?? this.sectionIdentifier,
            sectionTitle: sectionTitle ?? this.sectionTitle,
            content: content ?? this.content,
            parentId: parentId ?? this.parentId,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory TermsAndConditionsDetails.fromJson(Map<String, dynamic> json){ 
        return TermsAndConditionsDetails(
            id: json["id"],
            sectionIdentifier: json["sectionIdentifier"],
            sectionTitle: json["sectionTitle"],
            content: json["content"],
            parentId: json["parentId"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: json["updatedAt"],
            deletedAt: json["deletedAt"],
        );
    }

}
