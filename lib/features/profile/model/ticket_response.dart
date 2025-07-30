class TicketResponse {
  TicketResponse({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<Ticket> data;
  final int total;
  final PaginationInfo? pageMeta;

  TicketResponse copyWith({
    List<Ticket>? data,
    int? total,
    PaginationInfo? pageMeta,
  }) {
    return TicketResponse(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory TicketResponse.fromJson(Map<String, dynamic> json){
    return TicketResponse(
      data: json["data"] == null ? [] : List<Ticket>.from(json["data"]!.map((x) => Ticket.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PaginationInfo.fromJson(json["pageMeta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x?.toJson()).toList(),
    "total": total,
    "pageMeta": pageMeta?.toJson(),
  };

}

class Ticket {
  Ticket({
    required this.ticketId,
    required this.customerId,
    required this.issueCategory,
    required this.title,
    required this.description,
    required this.attachment,
    required this.status,
    required this.ticketStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String ticketId;
  final String customerId;
  final String issueCategory;
  final String title;
  final String description;
  final List<String> attachment;
  final int status;
  final int ticketStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Ticket copyWith({
    String? ticketId,
    String? customerId,
    String? issueCategory,
    String? title,
    String? description,
    List<String>? attachment,
    int? status,
    int? ticketStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return Ticket(
      ticketId: ticketId ?? this.ticketId,
      customerId: customerId ?? this.customerId,
      issueCategory: issueCategory ?? this.issueCategory,
      title: title ?? this.title,
      description: description ?? this.description,
      attachment: attachment ?? this.attachment,
      status: status ?? this.status,
      ticketStatus: ticketStatus ?? this.ticketStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json){
    return Ticket(
      ticketId: json["ticket_id"] ?? "",
      customerId: json["customerId"] ?? "",
      issueCategory: json["issueCategory"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      attachment: json["attachment"] == null ? [] : List<String>.from(json["attachment"]!.map((x) => x)),
      status: json["status"] ?? 0,
      ticketStatus: json["ticketStatus"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ticket_id": ticketId,
    "customerId": customerId,
    "issueCategory": issueCategory,
    "title": title,
    "description": description,
    "attachment": attachment.map((x) => x).toList(),
    "status": status,
    "ticketStatus": ticketStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class PaginationInfo {
  PaginationInfo({
    required this.page,
    required this.pageCount,
    required this.nextPage,
    required this.pageSize,
    required this.total,
  });

  final int page;
  final int pageCount;
  final dynamic nextPage;
  final int pageSize;
  final int total;

  PaginationInfo copyWith({
    int? page,
    int? pageCount,
    dynamic? nextPage,
    int? pageSize,
    int? total,
  }) {
    return PaginationInfo(
      page: page ?? this.page,
      pageCount: pageCount ?? this.pageCount,
      nextPage: nextPage ?? this.nextPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
    );
  }

  factory PaginationInfo.fromJson(Map<String, dynamic> json){
    return PaginationInfo(
      page: json["page"] ?? 0,
      pageCount: json["pageCount"] ?? 0,
      nextPage: json["nextPage"],
      pageSize: json["pageSize"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageCount": pageCount,
    "nextPage": nextPage,
    "pageSize": pageSize,
    "total": total,
  };

}
