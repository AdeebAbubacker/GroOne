class DocumentUploadResponse {
  final bool success;
  final String message;
  final DocumentUploadData? data;

  DocumentUploadResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? DocumentUploadData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DocumentUploadData {
  final String url;

  DocumentUploadData({
    required this.url,
  });

  factory DocumentUploadData.fromJson(Map<String, dynamic> json) {
    return DocumentUploadData(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
} 