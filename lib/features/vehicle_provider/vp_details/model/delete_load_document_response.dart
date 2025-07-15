class DeleteLoadDocumentResponse {
  String? deleteLoadDocumentResponse;

  DeleteLoadDocumentResponse.fromJson(Map<String,dynamic> json){
    deleteLoadDocumentResponse=json['message'];
  }
}