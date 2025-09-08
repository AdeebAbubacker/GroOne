class TicketMessageResponse {
  TicketMessageResponse({
    required this.messageId,
    required this.ticketId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String messageId;
  final String ticketId;
  final String senderId;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  TicketMessageResponse copyWith({
    String? messageId,
    String? ticketId,
    String? senderId,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return TicketMessageResponse(
      messageId: messageId ?? this.messageId,
      ticketId: ticketId ?? this.ticketId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory TicketMessageResponse.fromJson(Map<String, dynamic> json){
    return TicketMessageResponse(
      messageId: json["message_id"] ?? "",
      ticketId: json["ticketId"] ?? "",
      senderId: json["senderId"] ?? "",
      message: json["message"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "message_id": messageId,
    "ticketId": ticketId,
    "senderId": senderId,
    "message": message,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
