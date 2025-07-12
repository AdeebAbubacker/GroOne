class UploadDocumentResponse {
  final String? url;
  final String? filePath;
  final String? originalName;
  final int? size;
  final String? mimeType;

  UploadDocumentResponse({
    this.url,
    this.filePath,
    this.originalName,
    this.size,
    this.mimeType,
  });

  // Factory constructor to create from JSON
  factory UploadDocumentResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UploadDocumentResponse();
    return UploadDocumentResponse(
      url: json['url'] as String?,
      filePath: json['filePath'] as String?,
      originalName: json['originalName'] as String?,
      size: json['size'] as int?,
      mimeType: json['mimeType'] as String?,
    );
  }


}
