import 'package:gro_one_app/data/model/serializable.dart';

class VpCreationApiRequest implements Serializable<VpCreationApiRequest> {
  final String? customerName;
  final String? mobileNumber;
  final String? companyName;
  final int? companyTypeId;
  final List<int>? truckType;
  final String? ownedTrucks;
  final String? attachedTrucks;
  final List<int>? preferredLanes;
  final String? uploadRc;
  final String? emailId;
  final String? pincode;
  final int? roleId;
  VpCreationApiRequest({
    this.customerName,
    this.mobileNumber,
     this.companyName,
     this.companyTypeId,
     this.truckType,
     this.ownedTrucks,
     this.attachedTrucks,
     this.preferredLanes,
    this.uploadRc,
    this.emailId,
    this.pincode,
    this.roleId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName ?? "",
      "mobileNumber": mobileNumber?.trim() ?? "",
      "companyName": companyName ?? "",
      "companyTypeId" : companyTypeId ?? "",
      "truckType": truckType ?? [],
      "ownedTrucks": int.tryParse(ownedTrucks ?? "") ?? 0,
      "attachedTrucks": int.tryParse(attachedTrucks ?? "") ?? 0,
      "preferredLanes": preferredLanes ?? [] ,
      "uploadRc": uploadRc ?? "",
      "emailId": emailId ?? "",
      "pincode": pincode ?? "",
      "roleId": roleId ?? 0
    };
  }

  VpCreationApiRequest copyWith({
    String? customerName,
    String? mobileNumber,
    String? companyName,
    int? companyTypeId,
    List<int>? truckType,
    String? ownedTrucks,
    String? attachedTrucks,
    List<int>? preferredLanes,
    String? uploadRc,
    String? emailId,
    String? pincode,
    int? roleId,
  }) {
    return VpCreationApiRequest(
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      companyName: companyName ?? this.companyName,
      companyTypeId: companyTypeId ?? this.companyTypeId,
      truckType: truckType ?? this.truckType,
      ownedTrucks: ownedTrucks ?? this.ownedTrucks,
      attachedTrucks: attachedTrucks ?? this.attachedTrucks,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      uploadRc: uploadRc ?? this.uploadRc,
      emailId: emailId ?? this.emailId,
      pincode: pincode ?? this.pincode,
      roleId: roleId ?? this.roleId,
    );
  }
}
