import 'address_response.dart';

class FaqResponse {
  FaqResponse({
    required this.message,
    required this.data,
  });

  final String message;
  final FAQ? data;

  FaqResponse copyWith({
    String? message,
    FAQ? data,
  }) {
    return FaqResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory FaqResponse.fromJson(Map<String, dynamic> json){
    return FaqResponse(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : FAQ.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };

}

class FAQ {
  FAQ({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<FAQList> data;
  final int total;
  final PaginationInfo? pageMeta;

  FAQ copyWith({
    List<FAQList>? data,
    int? total,
    PaginationInfo? pageMeta,
  }) {
    return FAQ(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory FAQ.fromJson(Map<String, dynamic> json){
    return FAQ(
      data: json["data"] == null ? [] : List<FAQList>.from(json["data"]!.map((x) => FAQList.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PaginationInfo.fromJson(json["pageMeta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
    "total": total,
    "pageMeta": pageMeta?.toJson(),
  };

}

class FAQList {
  FAQList({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String question;
  final String answer;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FAQList copyWith({
    int? id,
    String? question,
    String? answer,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FAQList(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory FAQList.fromJson(Map<String, dynamic> json){
    return FAQList(
      id: json["id"] ?? 0,
      question: json["question"] ?? "",
      answer: json["answer"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
