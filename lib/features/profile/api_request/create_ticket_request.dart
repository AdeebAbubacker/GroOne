class CreateTicketRequest {
  CreateTicketRequest({
    this.customerId,
    required this.issueCategory,
    required this.title,
    required this.description,
    required this.attachmentLink,
    required this.ticketTag,
  });

  final String? customerId;
  final String issueCategory;
  final String title;
  final String description;
  final List<dynamic> attachmentLink;
  final String ticketTag;

  CreateTicketRequest copyWith({
    String? customerId,
    String? issueCategory,
    String? title,
    String? description,
    List<String>? attachmentLink,
    String? ticketTag,
  }) {
    return CreateTicketRequest(
      customerId: customerId ?? this.customerId,
      issueCategory: issueCategory ?? this.issueCategory,
      title: title ?? this.title,
      description: description ?? this.description,
      attachmentLink: attachmentLink ?? this.attachmentLink,
      ticketTag: ticketTag ?? this.ticketTag,
    );
  }

  factory CreateTicketRequest.fromJson(Map<String, dynamic> json){
    return CreateTicketRequest(
      customerId: json["customerId"] ?? "",
      issueCategory: json["issueCategory"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      attachmentLink: json["attachmentLink"] == null ? [] : List<String>.from(json["attachmentLink"]!.map((x) => x)),
      ticketTag: json['ticketTag'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "issueCategory": issueCategory,
    "title": title,
    "description": description,
    "attachmentLink": attachmentLink.map((x) => x).toList(),
    "ticketTag": ticketTag,
  };

  fromJson() {}

}
