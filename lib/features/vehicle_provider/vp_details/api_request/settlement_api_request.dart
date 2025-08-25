import 'package:gro_one_app/data/model/serializable.dart';

class SettlementApiRequest extends Serializable<SettlementApiRequest> {
  SettlementApiRequest({
    required this.vehicleId,
    required this.loadId,
    required this.noOfDays,
    required this.amountPerDay,
    required this.loadingCharge,
    required this.unloadingCharge,
  });

  final String vehicleId;
  final String loadId;
  final int noOfDays;
  final int amountPerDay;
  final int loadingCharge;
  final int unloadingCharge;

  SettlementApiRequest copyWith({
    String? vehicleId,
    String? loadId,
    int? noOfDays,
    int? amountPerDay,
    int? loadingCharge,
    int? unloadingCharge,
  }) {
    return SettlementApiRequest(
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      noOfDays: noOfDays ?? this.noOfDays,
      amountPerDay: amountPerDay ?? this.amountPerDay,
      loadingCharge: loadingCharge ?? this.loadingCharge,
      unloadingCharge: unloadingCharge ?? this.unloadingCharge,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{"vehicleId": vehicleId, "loadId": loadId};

    if (noOfDays != 0) {
      data["noOfDays"] = noOfDays;
    }
    if (amountPerDay != 0) {
      data["amountPerDay"] = amountPerDay;
    }
    if (loadingCharge != 0) {
      data["loadingCharge"] = loadingCharge;
    }
    if (unloadingCharge != 0) {
      data["unloadingCharge"] = unloadingCharge;
    }

    return data;
  }
}
