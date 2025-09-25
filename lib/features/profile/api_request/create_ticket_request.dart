class CreateTicketRequest {
  CreateTicketRequest({
    this.customerId,
    required this.issueCategoryUuid,
    required this.title,
    required this.description,
    required this.attachmentLink,
  });

  final String? customerId;
  final String? issueCategoryUuid;
  final String title;
  final String description;
  final List<dynamic> attachmentLink;

  CreateTicketRequest copyWith({
    String? customerId,
    String? issueCategoryUuid,
    String? title,
    String? description,
    List<String>? attachmentLink,
  }) {
    return CreateTicketRequest(
      customerId: customerId ?? this.customerId,
      issueCategoryUuid: issueCategoryUuid ?? this.issueCategoryUuid,
      title: title ?? this.title,
      description: description ?? this.description,
      attachmentLink: attachmentLink ?? this.attachmentLink,
    );
  }

  factory CreateTicketRequest.fromJson(Map<String, dynamic> json){
    return CreateTicketRequest(
      customerId: json["customerId"] ?? "",
      issueCategoryUuid: json["issueCategoryUuid"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      attachmentLink: json["attachmentLink"] == null ? [] : List<String>.from(json["attachmentLink"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "issueCategoryUuid": issueCategoryUuid,
    "title": title,
    "description": description,
    "attachmentLink": attachmentLink.map((x) => x).toList(),
  };

  fromJson() {}

}
