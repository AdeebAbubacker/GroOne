import 'package:gro_one_app/data/model/serializable.dart';

class DamageApiRequest extends Serializable<DamageApiRequest> {
  DamageApiRequest({
    required this.vehicleId,
    required this.loadId,
    required this.itemName,
    required this.quantity,
    required this.description,
    required this.image,
  });

  final String vehicleId;
  final String loadId;
  final String itemName;
  final int quantity;
  final String description;
  final List<String> image;

  DamageApiRequest copyWith({
    String? vehicleId,
    String? loadId,
    String? itemName,
    int? quantity,
    String? description,
    List<String>? image,
  }) {
    return DamageApiRequest(
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "loadId": loadId,
    "itemName": itemName,
    "quantity": quantity,
    "description": description,
    "image": image.map((x) => x).toList(),
  };

}
