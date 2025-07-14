class CreateDocumentRequest {
  int? documentTypeId;
  String? title;
  String? description;
  String? originalFilename;
  String? filePath;
  int? fileSize;
  String? mimeType;
  String? fileExtension;


  CreateDocumentRequest({
    this.documentTypeId,
    this.title,
    this.description,
    this.originalFilename,
    this.filePath,
    this.fileSize,
    this.mimeType,
    this.fileExtension,


  });


  Map<String, dynamic> toJson(String? createdBy) {
    return {
      'document_type_id': documentTypeId,
      'title': title,
      'description': description,
      'original_filename': originalFilename,
      'file_path': filePath,
      'file_size': fileSize,
      'mime_type': mimeType,
      'file_extension': fileExtension,
      'status': 1,
      'created_by': createdBy,
    };
  }
}
