import 'package:gro_one_app/data/model/serializable.dart';

class CreateDocumentApiRequest extends Serializable<CreateDocumentApiRequest> {
  CreateDocumentApiRequest({
    required this.documentTypeId,
    required this.title,
    required this.description,
    required this.originalFilename,
    required this.filePath,
    required this.fileSize,
    required this.mimeType,
    required this.fileExtension,
             this.status,
             this.createdBy,
  });

  final int? documentTypeId;
  final String? title;
  final String? description;
  final String? originalFilename;
  final String? filePath;
  final int? fileSize;
  final String? mimeType;
  final String? fileExtension;
  final int? status;
  final String? createdBy;

  CreateDocumentApiRequest copyWith({
    int? documentTypeId,
    String? title,
    String? description,
    String? originalFilename,
    String? filePath,
    int? fileSize,
    String? mimeType,
    String? fileExtension,
    int? status,
    String? createdBy,
  }) {
    return CreateDocumentApiRequest(
      documentTypeId: documentTypeId ?? this.documentTypeId,
      title: title ?? this.title,
      description: description ?? this.description,
      originalFilename: originalFilename ?? this.originalFilename,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      fileExtension: fileExtension ?? this.fileExtension,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
    );
  }


  @override
  Map<String, dynamic> toJson() => {
    "document_type_id": documentTypeId ?? "",
    "title": title ?? "",
    "description": description ?? "",
    "original_filename": originalFilename ?? "",
    "file_path": filePath ?? "",
    "file_size": fileSize ?? "",
    "mime_type": mimeType ?? "",
    "file_extension": fileExtension ?? "",
    "status": status ?? 1,
    "created_by": createdBy ?? "",
  };

}
