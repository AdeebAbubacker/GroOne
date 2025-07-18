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
    print('🔍 DocumentUploadResponse.fromJson called with: $json');
    
    // The API response appears to be the direct data structure
    // Based on the user's message, it should be: {url: "...", filePath: "...", originalName: "...", size: ..., mimeType: ...}
    DocumentUploadData? uploadData;
    
    if (json['url'] != null) {
      // Direct structure: {url: "...", filePath: "...", originalName: "..."}
      uploadData = DocumentUploadData.fromJson(json);
    } else if (json['data'] != null && json['data']['url'] != null) {
      // Nested structure: {success: true, data: {url: "..."}}
      uploadData = DocumentUploadData.fromJson(json['data']);
    }
    
    print('🔍 Parsed uploadData: $uploadData');
    
    return DocumentUploadResponse(
      success: json['success'] ?? true, // Default to true if not specified
      message: json['message'] ?? '',
      data: uploadData,
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
  final String? filePath;
  final String? originalName;
  final int? size;
  final String? mimeType;

  DocumentUploadData({
    required this.url,
    this.filePath,
    this.originalName,
    this.size,
    this.mimeType,
  });

  factory DocumentUploadData.fromJson(Map<String, dynamic> json) {
    print('🔍 DocumentUploadData.fromJson called with: $json');
    return DocumentUploadData(
      url: json['url'] ?? '',
      filePath: json['filePath'],
      originalName: json['originalName'],
      size: json['size'],
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'filePath': filePath,
      'originalName': originalName,
      'size': size,
      'mimeType': mimeType,
    };
  }
} 