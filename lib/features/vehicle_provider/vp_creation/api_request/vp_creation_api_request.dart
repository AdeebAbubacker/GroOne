import 'package:gro_one_app/data/model/serializable.dart';

class VpCreationApiRequest implements Serializable<VpCreationApiRequest> {
  final String? customerName;
  final String? mobileNumber;
  final String? companyName;
  final String? truckType;
  final String? ownedTrucks;
  final String? attachedTrucks;
  final String? preferredLanes;
  VpCreationApiRequest({required this.mobileNumber, required this.companyName, required this.truckType, required this.attachedTrucks, required this.preferredLanes, required this.ownedTrucks, required this.customerName});

  @override
  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName ?? "",
      "mobileNumber": mobileNumber != null ? mobileNumber?.trim() : "",
      "companyName": companyName ?? "",
      "truckType": [5],
      "ownedTrucks": ownedTrucks != null ? int.parse(ownedTrucks!) : 0,
      "attachedTrucks": attachedTrucks != null ? int.parse(attachedTrucks!) : 0,
      "preferredLanes": [10],
      "uploadRc": "https://example.com/rc-document.pdf"
    };
  }

}