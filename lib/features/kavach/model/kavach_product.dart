class KavachProduct {
  final String id;
  final String name;
  final String part;
  final double price;
  final double gstPerc;
  final String productDesc;
  final String fileKey;
  final String? unitMeasurement;
  final double? purchasePrice;

  KavachProduct({
    required this.id,
    required this.name,
    required this.part,
    required this.price,
    required this.gstPerc,
    required this.productDesc,
    required this.fileKey,
    required this.unitMeasurement,
    required this.purchasePrice,
  });

  factory KavachProduct.fromJson(Map<String, dynamic> json) {
    return KavachProduct(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      part: json['part'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      gstPerc: double.tryParse(json['gst_perc']?.toString() ?? '') ?? 0.0,
      productDesc: json['product_desc'] ?? '',
      fileKey: json['file_key'] ?? '',
      unitMeasurement: json['unit_measurement']?.toString() ?? '',
      purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? '') ?? 0.0,
    );
  }
}
