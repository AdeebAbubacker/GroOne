import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';

class VpMyLoadResponse {
  VpMyLoadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<VpLoadsList> data;

  factory VpMyLoadResponse.fromJson(Map<String, dynamic> json){
    return VpMyLoadResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<VpLoadsList>.from(json["data"]['data']!.map((x) => VpLoadsList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class VpLoadsList {
  VpLoadsList({
    required this.id,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.assignStatus,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.notes,
    required this.rate,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.truckType,
    required this.commodity,
    required this.customer,
    required this.customerDetail,
    required this.loadId,
    required this.pickUpWholeAddr,
    required this.dropWholeAddr,
    required this.vpRate,
    required this.vpMaxRate,
    required this.loadStatusDetails,
  });


  /// regarding rate master
  final String? pickUpWholeAddr;
  final String? dropWholeAddr;
  final String? vpRate;
  final String? vpMaxRate;




  final String id;
  final dynamic customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final num assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final String notes;
  final String rate;
  final num status;
  final String? loadId;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final TruckType? truckType;
  final Commodity? commodity;
  final Customer? customer;
  final CustomerDetail? customerDetail;

  final LoadStatusDetails? loadStatusDetails;

  factory VpLoadsList.fromJson(Map<String, dynamic> json){

    return VpLoadsList(
      loadStatusDetails: json['loadStatusDetails']!=null ? LoadStatusDetails.fromJson(json['loadStatusDetails']):null,
      vpMaxRate:  json['loadPrice']!=null ?  json['loadPrice']['vpMaxRate']?.toString()??"" :"",
      vpRate:  json['loadPrice']!=null ?  json['loadPrice']['vpRate']?.toString()??"":"" ,
      dropWholeAddr:  json['loadRoute']!=null ? json['loadRoute']['dropWholeAddr']?.toString()??"":"",
      pickUpWholeAddr: json['loadRoute']!=null  ? json['loadRoute']['pickUpWholeAddr']?.toString()??"":"",
      pickUpAddr: json['loadRoute']!=null ? json['loadRoute']["pickUpAddr"] ?? "":"",
      pickUpLatlon:  json['loadRoute']!=null ? json['loadRoute']["pickUpLatlon"] ?? "":"",
      dropAddr: json['loadRoute']!=null  ? json['loadRoute']["dropAddr"] ?? "":"",
      dropLatlon:  json['loadRoute']!=null ? json['loadRoute']["dropLatlon"] ?? "":"",


      loadId: json['loadSeriesId']??"",
      id: json["loadId"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,

      assignStatus: json["loadStatusId"] ?? 0,

      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight:  json['weightage']!=null ?json['weightage']['value'] :0,
      notes: json["notes"] ?? "",
      rate: json["rate"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      customerDetail: json["customerDetail"] == null ? null : CustomerDetail.fromJson(json["customerDetail"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "commodityId": commodityId,
    "truckTypeId": truckTypeId,
    "pickUpAddr": pickUpAddr,
    "assignStatus": assignStatus,
    "pickUpLatlon": pickUpLatlon,
    "dropAddr": dropAddr,
    "dropLatlon": dropLatlon,
    "dueDate": dueDate?.toIso8601String(),
    "consignmentWeight": consignmentWeight,
    "notes": notes,
    "rate": rate,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "truckType": truckType?.toJson(),
    "commodity": commodity?.toJson(),
    "customer": customer?.toJson(),
    "customerDetail": customerDetail?.toJson(),
  };

}

class Commodity {
  Commodity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final dynamic description;
  final dynamic iconUrl;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory Commodity.fromJson(Map<String, dynamic> json){
    return Commodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"],
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "iconUrl": iconUrl,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class Customer {
  Customer({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
    required this.blueId,
    required this.password,
    required this.otp,
    required this.otpAttempt,
    required this.isKyc,
    required this.roleId,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final dynamic emailId;
  final dynamic blueId;
  final dynamic password;
  final num otp;
  final num otpAttempt;
  final bool isKyc;
  final num roleId;
  final bool tempFlg;
  final num status;
  final bool isLogin;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"] ?? "",
      password: json["password"],
      otp: json["otp"] ?? 0,
      otpAttempt: json["otpAttempt"] ?? 0,
      isKyc: json["isKyc"] ?? false,
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "mobileNumber": mobileNumber,
    "emailId": emailId,
    "blueId": blueId,
    "password": password,
    "otp": otp,
    "otpAttempt": otpAttempt,
    "isKyc": isKyc,
    "roleId": roleId,
    "tempFlg": tempFlg,
    "status": status,
    "isLogin": isLogin,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class CustomerDetail {
  CustomerDetail({
    required this.id,
    required this.customerId,
    required this.companyName,
    required this.companyTypeId,
    required this.gstin,
    required this.gstinDocLink,
    required this.aadhar,
    required this.aadharDocLink,
    required this.pan,
    required this.panDocLink,
    required this.cheque,
    required this.chequeDocLink,
    required this.drivingLicense,
    required this.drivingLicenseDocLink,
    required this.tds,
    required this.tdsDocLink,
    required this.tan,
    required this.tanDocLink,
    required this.isAadhar,
    required this.isGstin,
    required this.isTan,
    required this.isPan,
    required this.bankAccount,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.status,
    required this.truckType,
    required this.ownedTrucks,
    required this.attachedTrucks,
    required this.preferredLanes,
    required this.uploadRc,
    required this.pincode,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.profileImageUrl,
    required this.location,
    required this.createdAt,
    required this.deletedAt,
    required this.customerDetailCustomerId,
  });

  final int id;
  final num customerId;
  final String companyName;
  final num companyTypeId;
  final dynamic gstin;
  final dynamic gstinDocLink;
  final dynamic aadhar;
  final dynamic aadharDocLink;
  final dynamic pan;
  final dynamic panDocLink;
  final dynamic cheque;
  final dynamic chequeDocLink;
  final dynamic drivingLicense;
  final dynamic drivingLicenseDocLink;
  final dynamic tds;
  final dynamic tdsDocLink;
  final dynamic tan;
  final dynamic tanDocLink;
  final bool isAadhar;
  final bool isGstin;
  final bool isTan;
  final bool isPan;
  final dynamic bankAccount;
  final dynamic bankName;
  final dynamic branchName;
  final dynamic ifscCode;
  final num status;
  final dynamic truckType;
  final dynamic ownedTrucks;
  final dynamic attachedTrucks;
  final dynamic preferredLanes;
  final dynamic uploadRc;
  final String pincode;
  final dynamic address1;
  final dynamic address2;
  final dynamic address3;
  final dynamic profileImageUrl;
  final dynamic location;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final int customerDetailCustomerId;

  factory CustomerDetail.fromJson(Map<String, dynamic> json){
    return CustomerDetail(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      companyName: json["companyName"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
      gstin: json["gstin"] ?? "",
      gstinDocLink: json["gstinDocLink"] ?? "",
      aadhar: json["aadhar"] ?? "",
      aadharDocLink: json["aadharDocLink"] ?? "",
      pan: json["pan"] ?? "",
      panDocLink: json["panDocLink"] ?? "",
      cheque: json["cheque"] ?? "",
      chequeDocLink: json["chequeDocLink"] ?? "",
      drivingLicense: json["drivingLicense"] ?? "",
      drivingLicenseDocLink: json["drivingLicenseDocLink"] ?? "",
      tds: json["tds"] ?? "",
      tdsDocLink: json["tdsDocLink"] ?? "",
      tan: json["tan"] ?? "",
      tanDocLink: json["tanDocLink"] ?? "",
      isAadhar: json["isAadhar"] ?? false,
      isGstin: json["isGstin"] ?? false,
      isTan: json["isTan"] ?? false,
      isPan: json["isPan"] ?? false,
      bankAccount: json["bankAccount"] ?? "",
      bankName: json["bankName"] ?? "",
      branchName: json["branchName"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
      status: json["status"] ?? 0,
      truckType: json["truckType"] ?? "",
      ownedTrucks: json["ownedTrucks"] ?? "",
      attachedTrucks: json["attachedTrucks"] ?? "",
      preferredLanes: json["preferredLanes"] ?? "",
      uploadRc: json["uploadRc"] ?? "",
      pincode: json["pincode"] ?? "",
      address1: json["address1"] ?? "",
      address2: json["address2"] ?? "",
      address3: json["address3"] ?? "",
      profileImageUrl: json["profileImageUrl"] ?? "",
      location: json["location"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"], // can be null
      customerDetailCustomerId: json["customer_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "companyName": companyName,
    "companyTypeId": companyTypeId,
    "gstin": gstin,
    "gstinDocLink": gstinDocLink,
    "aadhar": aadhar,
    "aadharDocLink": aadharDocLink,
    "pan": pan,
    "panDocLink": panDocLink,
    "cheque": cheque,
    "chequeDocLink": chequeDocLink,
    "drivingLicense": drivingLicense,
    "drivingLicenseDocLink": drivingLicenseDocLink,
    "tds": tds,
    "tdsDocLink": tdsDocLink,
    "tan": tan,
    "tanDocLink": tanDocLink,
    "isAadhar": isAadhar,
    "isGstin": isGstin,
    "isTan": isTan,
    "isPan": isPan,
    "bankAccount": bankAccount,
    "bankName": bankName,
    "branchName": branchName,
    "ifscCode": ifscCode,
    "status": status,
    "truckType": truckType,
    "ownedTrucks": ownedTrucks,
    "attachedTrucks": attachedTrucks,
    "preferredLanes": preferredLanes,
    "uploadRc": uploadRc,
    "pincode": pincode,
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "profileImageUrl": profileImageUrl,
    "location": location,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "customer_id": customerDetailCustomerId,
  };

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
    required this.subType,
    required this.iconUrl,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String type;
  final String subType;
  final dynamic iconUrl;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "subType": subType,
    "iconUrl": iconUrl,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
