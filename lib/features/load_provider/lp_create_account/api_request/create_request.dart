class CreateRequest {
  CreateRequest({
    required this.customerName,
    required this.mobileNumber,
    required this.companyName,
    required this.companyTypeId,
    required this.pincode,
  });

  final String customerName;
  final String mobileNumber;
  final String companyName;
  final num companyTypeId;
  final String pincode;

  factory CreateRequest.fromJson(Map<String, dynamic> json){
    return CreateRequest(
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      companyName: json["companyName"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
      pincode: json["pincode"] ?? "",
    );
  }

}
