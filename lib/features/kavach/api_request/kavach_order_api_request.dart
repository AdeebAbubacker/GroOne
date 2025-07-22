class KavachOrderVehicle {
  final String vehicleNumber;

  KavachOrderVehicle({required this.vehicleNumber});

  Map<String, dynamic> toJson() => {
    "vehicleNumber": vehicleNumber,
  };
}

class KavachOrderItem {
  final int productServiceId;
  final int noOfProducts;
  final double unitPrice;
  final double totalPrice;
  final int stockAvailable;
  final List<KavachOrderVehicle> vehicleNumbers;

  KavachOrderItem({
    required this.productServiceId,
    required this.noOfProducts,
    required this.unitPrice,
    required this.totalPrice,
    required this.stockAvailable,
    required this.vehicleNumbers,
  });

  Map<String, dynamic> toJson() => {
    "productServiceId": productServiceId,
    "noOfProducts": noOfProducts,
    "unitPrice": unitPrice,
    "totalPrice": totalPrice,
    "stockAvailable": stockAvailable,
    "vehicle_number": vehicleNumbers.map((v) => v.toJson()).toList(),
  };
}

class KavachOrderRequest {
  final String orderSource;
  final bool isOrderPaid;
  final String customerId;
  final int createdEmpUserId;
  final String? createdEmpId;
  final String orderReferencedBy;
  final double totalPrice;
  final int categoryId;
  final String shippingPersonIncharge;
  final String shippingPersonContactNo;
  final Map<String, dynamic> customerInfo;
  final Map<String, dynamic> billingAddress;
  final Map<String, dynamic> shippingAddress;
  final List<KavachOrderItem> orders;

  KavachOrderRequest({
    required this.orderSource,
    required this.isOrderPaid,
    required this.customerId,
    required this.createdEmpUserId,
    this.createdEmpId,
    required this.orderReferencedBy,
    required this.totalPrice,
    required this.categoryId,
    required this.shippingPersonIncharge,
    required this.shippingPersonContactNo,
    required this.customerInfo,
    required this.billingAddress,
    required this.shippingAddress,
    required this.orders,
  });

  Map<String, dynamic> toJson() {
    final json = {
      "orderSource": orderSource,
      "isOrderPaid": isOrderPaid,
      "customerId": customerId,
      "createdEmpUserId": createdEmpUserId,
      "orderReferencedBy": orderReferencedBy,
      "totalPrice": totalPrice,
      "categoryId": categoryId,
      "shippingPersonIncharge": shippingPersonIncharge,
      "shippingPersonContactNo": shippingPersonContactNo,
      "customerInfo": customerInfo,
      "billingAddress": billingAddress,
      "shippingAddress": shippingAddress,
      "orders": orders.map((o) => o.toJson()).toList(),
    };
    
    // Add createdEmpId only if it's not null
    if (createdEmpId != null) {
      json["createdEmpId"] = createdEmpId!;
    }
    
    return json;
  }
}

