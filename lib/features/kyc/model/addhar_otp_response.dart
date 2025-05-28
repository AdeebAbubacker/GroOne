class AddharOtpResponse {
  AddharOtpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  factory AddharOtpResponse.fromJson(Map<String, dynamic> json){
    return AddharOtpResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.aadhaarNo,
    required this.requestId,
    required this.status,
    required this.isNumberLinked,
    required this.responseData,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String aadhaarNo;
  final String requestId;
  final bool status;
  final dynamic isNumberLinked;
  final ResponseData? responseData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"] ?? 0,
      aadhaarNo: json["aadhaar_no"] ?? "",
      requestId: json["request_id"] ?? "",
      status: json["status"] ?? false,
      isNumberLinked: json["is_number_linked"],
      responseData: json["response_data"] == null ? null : ResponseData.fromJson(json["response_data"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}

class ResponseData {
  ResponseData({
    required this.requestId,
    required this.taskId,
    required this.groupId,
    required this.success,
    required this.responseCode,
    required this.responseMessage,
    required this.metadata,
    required this.resultData,
    required this.requestTimestamp,
    required this.responseTimestamp,
  });

  final String requestId;
  final String taskId;
  final String groupId;
  final bool success;
  final String responseCode;
  final String responseMessage;
  final Metadata? metadata;
  final ResultData? resultData;
  final DateTime? requestTimestamp;
  final DateTime? responseTimestamp;

  factory ResponseData.fromJson(Map<String, dynamic> json){
    return ResponseData(
      requestId: json["request_id"] ?? "",
      taskId: json["task_id"] ?? "",
      groupId: json["group_id"] ?? "",
      success: json["success"] ?? false,
      responseCode: json["response_code"] ?? "",
      responseMessage: json["response_message"] ?? "",
      metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
      resultData: json["result"] == null ? null : ResultData.fromJson(json["result"]),
      requestTimestamp: DateTime.tryParse(json["request_timestamp"] ?? ""),
      responseTimestamp: DateTime.tryParse(json["response_timestamp"] ?? ""),
    );
  }

}

class Metadata {
  Metadata({
    required this.billable,
    required this.reasonCode,
    required this.reasonMessage,
  });

  final String billable;
  final String reasonCode;
  final String reasonMessage;

  factory Metadata.fromJson(Map<String, dynamic> json){
    return Metadata(
      billable: json["billable"] ?? "",
      reasonCode: json["reason_code"] ?? "",
      reasonMessage: json["reason_message"] ?? "",
    );
  }

}

class ResultData {
  ResultData({
    required this.userFullName,
    required this.userAadhaarNumber,
    required this.userDob,
    required this.userGender,
    required this.userAddress,
    required this.addressZip,
    required this.userProfileImage,
    required this.userHasImage,
    required this.aadhaarXmlRaw,
    required this.userZipData,
    required this.userParentName,
    required this.aadhaarShareCode,
    required this.userMobileVerified,
    required this.referenceId,
  });

  final String userFullName;
  final String userAadhaarNumber;
  final String userDob;
  final String userGender;
  final UserAddress? userAddress;
  final String addressZip;
  final String userProfileImage;
  final bool userHasImage;
  final String aadhaarXmlRaw;
  final String userZipData;
  final String userParentName;
  final String aadhaarShareCode;
  final bool userMobileVerified;
  final String referenceId;

  factory ResultData.fromJson(Map<String, dynamic> json){
    return ResultData(
      userFullName: json["user_full_name"] ?? "",
      userAadhaarNumber: json["user_aadhaar_number"] ?? "",
      userDob: json["user_dob"] ?? "",
      userGender: json["user_gender"] ?? "",
      userAddress: json["user_address"] == null ? null : UserAddress.fromJson(json["user_address"]),
      addressZip: json["address_zip"] ?? "",
      userProfileImage: json["user_profile_image"] ?? "",
      userHasImage: json["user_has_image"] ?? false,
      aadhaarXmlRaw: json["aadhaar_xml_raw"] ?? "",
      userZipData: json["user_zip_data"] ?? "",
      userParentName: json["user_parent_name"] ?? "",
      aadhaarShareCode: json["aadhaar_share_code"] ?? "",
      userMobileVerified: json["user_mobile_verified"] ?? false,
      referenceId: json["reference_id"] ?? "",
    );
  }

}

class UserAddress {
  UserAddress({
    required this.house,
    required this.street,
    required this.landmark,
    required this.loc,
    required this.po,
    required this.dist,
    required this.subdist,
    required this.vtc,
    required this.state,
    required this.country,
  });

  final String house;
  final String street;
  final String landmark;
  final String loc;
  final String po;
  final String dist;
  final String subdist;
  final String vtc;
  final String state;
  final String country;

  factory UserAddress.fromJson(Map<String, dynamic> json){
    return UserAddress(
      house: json["house"] ?? "",
      street: json["street"] ?? "",
      landmark: json["landmark"] ?? "",
      loc: json["loc"] ?? "",
      po: json["po"] ?? "",
      dist: json["dist"] ?? "",
      subdist: json["subdist"] ?? "",
      vtc: json["vtc"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
    );
  }

}
