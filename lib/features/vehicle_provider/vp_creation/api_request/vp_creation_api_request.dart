import 'package:gro_one_app/data/model/serializable.dart';

class VpCreationApiRequest implements Serializable<VpCreationApiRequest> {
  final String? customerName;
  final String? mobileNumber;
  final String? companyName;
  final String? truckType;
  final String? ownedTrucks;
  final String? attachedTrucks;
  final String? preferredLanes;
  final String? uploadRc;
  final String? emailId;
  VpCreationApiRequest({
    this.customerName,
    this.mobileNumber,
     this.companyName,
     this.truckType,
     this.ownedTrucks,
     this.attachedTrucks,
     this.preferredLanes,
    this.uploadRc,
    this.emailId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName ?? "",
      "mobileNumber": mobileNumber?.trim() ?? "",
      "companyName": companyName ?? "",
      "truckType": [5],
      "ownedTrucks": int.tryParse(ownedTrucks ?? "") ?? 0,
      "attachedTrucks": int.tryParse(attachedTrucks ?? "") ?? 0,
      "preferredLanes": [1],
      "uploadRc": uploadRc ?? "",
      "emailId": emailId ?? ""
    };
  }

  VpCreationApiRequest copyWith({
    String? customerName,
    String? mobileNumber,
    String? companyName,
    String? truckType,
    String? ownedTrucks,
    String? attachedTrucks,
    String? preferredLanes,
    String? uploadRc,
    String? emailId,
  }) {
    return VpCreationApiRequest(
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      companyName: companyName ?? this.companyName,
      truckType: truckType ?? this.truckType,
      ownedTrucks: ownedTrucks ?? this.ownedTrucks,
      attachedTrucks: attachedTrucks ?? this.attachedTrucks,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      uploadRc: uploadRc ?? this.uploadRc,
      emailId: emailId ?? this.emailId,
    );
  }
}
