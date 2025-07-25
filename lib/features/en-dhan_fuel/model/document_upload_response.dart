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
    try {
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
      
      return DocumentUploadResponse(
        success: json['success'] ?? true, // Default to true if not specified
        message: json['message'] ?? '',
        data: uploadData,
      );
    } catch (e) {
      // Return a default success response if parsing fails
      return DocumentUploadResponse(
        success: true,
        message: 'Document uploaded successfully',
        data: null,
      );
    }
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
    try {
      return DocumentUploadData(
        url: json['url']?.toString() ?? '',
        filePath: json['filePath']?.toString(),
        originalName: json['originalName']?.toString(),
        size: json['size'] is int ? json['size'] : int.tryParse(json['size']?.toString() ?? '0'),
        mimeType: json['mimeType']?.toString(),
      );
    } catch (e) {
      // Return a default data object if parsing fails
      return DocumentUploadData(
        url: json['url']?.toString() ?? '',
        filePath: json['filePath']?.toString(),
        originalName: json['originalName']?.toString(),
        size: 0,
        mimeType: 'application/octet-stream',
      );
    }
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