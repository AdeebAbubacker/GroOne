class CreateDocumentResponse {
  final String? documentId;
  final String? title;
  final String? path;



  CreateDocumentResponse({
    required this.documentId,
    required this.title,
    required this.path,
  });

  factory CreateDocumentResponse.fromJson(Map<String, dynamic> json) {
    return CreateDocumentResponse(
      documentId: json['data']['documentId'],
      title: json['data']['title'],
      path: json['data']['path'],
    );
  }
}