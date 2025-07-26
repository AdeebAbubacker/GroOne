class FaqResponse {
  FaqResponse({
    required this.message,
    required this.faqs,
  });

  final String message;
  final List<Faq> faqs;

  FaqResponse copyWith({
    String? message,
    List<Faq>? faqs,
  }) {
    return FaqResponse(
      message: message ?? this.message,
      faqs: faqs ?? this.faqs,
    );
  }

  factory FaqResponse.fromJson(Map<String, dynamic> json){
    return FaqResponse(
      message: json["message"] ?? "",
      faqs: json["data"] == null ? [] : List<Faq>.from(json["data"]!.map((x) => Faq.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": faqs.map((x) => x.toJson()).toList(),
  };

}

class Faq {
  Faq({
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

  Faq copyWith({
    int? id,
    String? question,
    String? answer,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Faq(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Faq.fromJson(Map<String, dynamic> json){
    return Faq(
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
