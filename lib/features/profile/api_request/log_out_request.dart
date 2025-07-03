class LogOutRequest {
  LogOutRequest({
    required this.customerId,
  });

  final String customerId;

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
  };

}
