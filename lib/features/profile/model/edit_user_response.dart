class EditUserResponse {
  String? message;
  dynamic data;

  EditUserResponse.fromJson(Map<String,dynamic> json){
    message=json['message'];
    data=json['customer'];
  }

}