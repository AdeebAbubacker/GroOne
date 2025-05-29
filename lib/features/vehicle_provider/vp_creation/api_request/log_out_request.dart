class LogOutRequest {
  LogOutRequest({
    required this.customerId,
  });

  final String customerId;

  factory LogOutRequest.fromJson(Map<String, dynamic> json){
    return LogOutRequest(
      customerId: json["customerId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
  };

}
