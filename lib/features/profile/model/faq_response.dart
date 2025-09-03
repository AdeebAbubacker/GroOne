class FaqResponse {
    FaqResponse({
        required this.message,
        required this.data,
    });

    final String message;
    final FaqResponseData? data;

    FaqResponse copyWith({
        String? message,
        FaqResponseData? data,
    }) {
        return FaqResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory FaqResponse.fromJson(Map<String, dynamic> json){ 
        return FaqResponse(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : FaqResponseData.fromJson(json["data"]),
        );
    }

}

class FaqResponseData {
    FaqResponseData({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<FaqData> data;
    final int total;
    final FaqPageMeta? pageMeta;

    FaqResponseData copyWith({
        List<FaqData>? data,
        int? total,
        FaqPageMeta? pageMeta,
    }) {
        return FaqResponseData(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory FaqResponseData.fromJson(Map<String, dynamic> json){ 
        return FaqResponseData(
            data: json["data"] == null ? [] : List<FaqData>.from(json["data"]!.map((x) => FaqData.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : FaqPageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class FaqData {
    FaqData({
        required this.id,
        required this.question,
        required this.slug,
        required this.answer,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    final int id;
    final String question;
    final dynamic slug;
    final String answer;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    FaqData copyWith({
        int? id,
        String? question,
        dynamic slug,
        String? answer,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return FaqData(
            id: id ?? this.id,
            question: question ?? this.question,
            slug: slug ?? this.slug,
            answer: answer ?? this.answer,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory FaqData.fromJson(Map<String, dynamic> json){ 
        return FaqData(
            id: json["id"] ?? 0,
            question: json["question"] ?? "",
            slug: json["slug"],
            answer: json["answer"] ?? "",
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

}

class FaqPageMeta {
    FaqPageMeta({
        required this.page,
        required this.pageCount,
        required this.nextPage,
        required this.pageSize,
        required this.total,
    });

    final String page;
    final int pageCount;
    final String nextPage;
    final String pageSize;
    final int total;

    FaqPageMeta copyWith({
        String? page,
        int? pageCount,
        String? nextPage,
        String? pageSize,
        int? total,
    }) {
        return FaqPageMeta(
            page: page ?? this.page,
            pageCount: pageCount ?? this.pageCount,
            nextPage: nextPage ?? this.nextPage,
            pageSize: pageSize ?? this.pageSize,
            total: total ?? this.total,
        );
    }

    factory FaqPageMeta.fromJson(Map<String, dynamic> json){ 
        return FaqPageMeta(
            page: json["page"] ?? "",
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"] ?? "",
            pageSize: json["pageSize"] ?? "",
            total: json["total"] ?? 0,
        );
    }

}
