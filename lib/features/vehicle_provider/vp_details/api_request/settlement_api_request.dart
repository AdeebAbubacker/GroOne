import 'package:gro_one_app/data/model/serializable.dart';

class SettlementApiRequest  extends Serializable<SettlementApiRequest>{
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
  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "loadId": loadId,
    "noOfDays": noOfDays,
    "amountPerDay": amountPerDay,
    "loadingCharge": loadingCharge,
    "unloadingCharge": unloadingCharge,
  };

}
