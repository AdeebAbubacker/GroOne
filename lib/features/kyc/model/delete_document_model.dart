class DeleteDocumentModel {
  DeleteDocumentModel({
    required this.message,
    required this.data,
  });

  final String message;
  final dynamic data;

  factory DeleteDocumentModel.fromJson(Map<String, dynamic> json){
    return DeleteDocumentModel(
      message: json["message"] ?? "",
      data: json["data"] ?? {},
    );
  }

}
