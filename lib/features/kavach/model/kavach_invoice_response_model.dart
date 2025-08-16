class KavachInvoiceResponse {
  final String url;
  final bool wasGenerated;
  final String message;
  final String timestamp;

  KavachInvoiceResponse({
    required this.url,
    required this.wasGenerated,
    required this.message,
    required this.timestamp,
  });

  factory KavachInvoiceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return KavachInvoiceResponse(
      url: data['url'] ?? '',
      wasGenerated: data['wasGenerated'] ?? false,
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }
}
