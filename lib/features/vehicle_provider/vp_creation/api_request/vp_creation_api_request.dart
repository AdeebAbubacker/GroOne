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
  VpCreationApiRequest({
    this.customerName,
    this.mobileNumber,
     this.companyName,
     this.truckType,
     this.ownedTrucks,
     this.attachedTrucks,
     this.preferredLanes,
    this.uploadRc,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName ?? "",
      "mobileNumber": mobileNumber?.trim() ?? "",
      "companyName": companyName ?? "",
      "truckType": [5], // Replace this with dynamic parsing if needed
      "ownedTrucks": int.tryParse(ownedTrucks ?? "") ?? 0,
      "attachedTrucks": int.tryParse(attachedTrucks ?? "") ?? 0,
      "preferredLanes": [10], // Replace this with dynamic parsing if needed
      "uploadRc": uploadRc ?? ""
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
    );
  }
}
