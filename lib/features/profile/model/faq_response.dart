class FaqResponse {
    FaqResponse({
        required this.message,
        required this.data,
    });

    final String message;
    final Data? data;

    FaqResponse copyWith({
        String? message,
        Data? data,
    }) {
        return FaqResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory FaqResponse.fromJson(Map<String, dynamic> json){ 
        return FaqResponse(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<Datum> data;
    final int total;
    final PageMeta? pageMeta;

    Data copyWith({
        List<Datum>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return Data(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class Datum {
    Datum({
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

    Datum copyWith({
        int? id,
        String? question,
        dynamic? slug,
        String? answer,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return Datum(
            id: id ?? this.id,
            question: question ?? this.question,
            slug: slug ?? this.slug,
            answer: answer ?? this.answer,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
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

class PageMeta {
    PageMeta({
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

    PageMeta copyWith({
        String? page,
        int? pageCount,
        String? nextPage,
        String? pageSize,
        int? total,
    }) {
        return PageMeta(
            page: page ?? this.page,
            pageCount: pageCount ?? this.pageCount,
            nextPage: nextPage ?? this.nextPage,
            pageSize: pageSize ?? this.pageSize,
            total: total ?? this.total,
        );
    }

    factory PageMeta.fromJson(Map<String, dynamic> json){ 
        return PageMeta(
            page: json["page"] ?? "",
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"] ?? "",
            pageSize: json["pageSize"] ?? "",
            total: json["total"] ?? 0,
        );
    }

}
