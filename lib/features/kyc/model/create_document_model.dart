class CreateDocumentModel {
  CreateDocumentModel({
    required this.message,
    required this.data,
  });

  final String message;
  final Data? data;

  factory CreateDocumentModel.fromJson(Map<String, dynamic> json){
    return CreateDocumentModel(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.documentId,
    required this.title,
    required this.path,
  });

  final String documentId;
  final String title;
  final String path;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      documentId: json["documentId"] ?? "",
      title: json["title"] ?? "",
      path: json["path"] ?? "",
    );
  }

}
