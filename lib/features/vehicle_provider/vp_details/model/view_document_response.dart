class ViewDocumentResponse {
  final String? documentId;
  final String? title;
  final String? documentType;
  final String? fileSize;
  final String? filePath;
  final String? originalFilename;

  ViewDocumentResponse({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.fileSize,
    required this.filePath,
    required this.originalFilename,
  });

  factory ViewDocumentResponse.fromJson(Map<String, dynamic> json) {
     json=json['data'];
     return ViewDocumentResponse(
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      documentType: json['documentType'] as String,
      fileSize: json['fileSize'] as String,
      filePath: json['filePath'] as String,
      originalFilename: json['originalFilename'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'title': title,
      'documentType': documentType,
      'fileSize': fileSize,
      'filePath': filePath,
      'originalFilename': originalFilename,
    };
  }
}
