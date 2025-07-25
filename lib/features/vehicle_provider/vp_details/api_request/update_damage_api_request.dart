import 'package:gro_one_app/data/model/serializable.dart';

class UpdateDamageApiRequest extends Serializable<UpdateDamageApiRequest>{
  UpdateDamageApiRequest({
    required this.itemName,
    required this.quantity,
    required this.description,
    required this.image,
  });

  final String itemName;
  final int quantity;
  final String description;
  final List<String> image;

  UpdateDamageApiRequest copyWith({
    String? itemName,
    int? quantity,
    String? description,
    List<String>? image,
  }) {
    return UpdateDamageApiRequest(
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }


  @override
  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "quantity": quantity,
    "description": description,
    "image": image.map((x) => x).toList(),
  };

}
