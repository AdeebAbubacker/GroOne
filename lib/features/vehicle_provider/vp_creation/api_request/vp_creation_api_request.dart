import 'package:gro_one_app/data/model/serializable.dart';

class VpCreationApiRequest implements Serializable<VpCreationApiRequest> {
  final String? customerName;
  final String? mobileNumber;
  final String? companyName;
  final String? companyTypeId;
  final List<int>? truckType;
  final String? ownedTrucks;
  final String? attachedTrucks;
  final String? preferredLanes;
  final String? uploadRc;
  final String? emailId;
  final String? pincode;
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
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName ?? "",
      "mobileNumber": mobileNumber?.trim() ?? "",
      "companyName": companyName ?? "",
      "companyTypeId" : companyTypeId ?? "",
      "truckType": truckType,
      "ownedTrucks": int.tryParse(ownedTrucks ?? "") ?? 0,
      "attachedTrucks": int.tryParse(attachedTrucks ?? "") ?? 0,
      "preferredLanes": [1],
      "uploadRc": uploadRc ?? "",
      "emailId": emailId ?? "",
      "pincode": pincode ?? ""
    };
  }

  VpCreationApiRequest copyWith({
    String? customerName,
    String? mobileNumber,
    String? companyName,
    String? companyTypeId,
    List<int>? truckType,
    String? ownedTrucks,
    String? attachedTrucks,
    String? preferredLanes,
    String? uploadRc,
    String? emailId,
    String? pincode,
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
    );
  }
}
