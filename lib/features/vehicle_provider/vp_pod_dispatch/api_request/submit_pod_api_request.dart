import 'package:gro_one_app/data/model/serializable.dart';

class SubmitPodApiRequest extends Serializable<SubmitPodApiRequest>{
  SubmitPodApiRequest({
    required this.loadId,
    required this.courierCompany,
    required this.awbNumber,
    required this.podCenterId,
    required this.podCenterName,
  });

  final String loadId;
  final String courierCompany;
  final String awbNumber;
  final String podCenterId;
  final String podCenterName;

  SubmitPodApiRequest copyWith({
    String? loadId,
    String? courierCompany,
    String? awbNumber,
    String? podCenterId,
    String? podCenterName,
  }) {
    return SubmitPodApiRequest(
      loadId: loadId ?? this.loadId,
      courierCompany: courierCompany ?? this.courierCompany,
      awbNumber: awbNumber ?? this.awbNumber,
      podCenterId: podCenterId ?? this.podCenterId,
      podCenterName: podCenterName ?? this.podCenterName,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "courierCompany": courierCompany,
    "awbNumber": awbNumber,
    "podCenterId": podCenterId,
    "podCenterName": podCenterName,
  };

}
