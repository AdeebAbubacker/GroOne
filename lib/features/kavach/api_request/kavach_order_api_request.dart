class KavachOrderVehicle {
  final String vehicleNumber;

  KavachOrderVehicle({required this.vehicleNumber});

  Map<String, dynamic> toJson() => {
    "vehicleNumber": vehicleNumber,
    "deviceUniqueNumber": "DEV123456789"
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

// class KavachOrderRequest {
//   final String orderSource;
//   final bool isOrderPaid;
//   final String customerId;
//   final double totalPrice;
//   final int categoryId;
//   final String shippingPersonIncharge;
//   final String shippingPersonContactNo;
//   final Map<String, dynamic> customerInfo;
//   final Map<String, dynamic> billingAddress;
//   final Map<String, dynamic> shippingAddress;
//   final List<KavachOrderItem> orders;
//
//   KavachOrderRequest({
//     required this.orderSource,
//     required this.isOrderPaid,
//     required this.customerId,
//     required this.totalPrice,
//     required this.categoryId,
//     required this.shippingPersonIncharge,
//     required this.shippingPersonContactNo,
//     required this.customerInfo,
//     required this.billingAddress,
//     required this.shippingAddress,
//     required this.orders,
//   });
//
//   Map<String, dynamic> toJson() => {
//     "orderSource": orderSource,
//     "isOrderPaid": isOrderPaid,
//     "customerId": customerId,
//     "totalPrice": totalPrice,
//     "categoryId": categoryId,
//     "shippingPersonIncharge": shippingPersonIncharge,
//     "shippingPersonContactNo": shippingPersonContactNo,
//     "customerInfo": customerInfo,
//     "billingAddress": billingAddress,
//     "shippingAddress": shippingAddress,
//     "orders": orders.map((o) => o.toJson()).toList(),
//   };
// }

class KavachOrderRequest {
  final String orderSource;
  final bool isOrderPaid;
  final String customerId;
  final double totalPrice;
  final int categoryId;
  final String shippingPersonIncharge;
  final String shippingPersonContactNo;
  final Map<String, dynamic> customerInfo;
  final Map<String, dynamic> billingAddress;
  final Map<String, dynamic> shippingAddress;
  final List<KavachOrderItem> orders;
  final int createdEmpUserId;
  final String orderReferencedBy;

  KavachOrderRequest({
    required this.orderSource,
    required this.isOrderPaid,
    required this.customerId,
    required this.totalPrice,
    required this.categoryId,
    required this.shippingPersonIncharge,
    required this.shippingPersonContactNo,
    required this.customerInfo,
    required this.billingAddress,
    required this.shippingAddress,
    required this.orders,
    required this.createdEmpUserId,
    required this.orderReferencedBy,
  });

  Map<String, dynamic> toJson() => {
    "orderSource": orderSource,
    "isOrderPaid": isOrderPaid,
    "customerId": customerId,
    "totalPrice": totalPrice,
    "categoryId": categoryId,
    "shippingPersonIncharge": shippingPersonIncharge,
    "shippingPersonContactNo": shippingPersonContactNo,
    "customerInfo": customerInfo,
    "billingAddress": billingAddress,
    "shippingAddress": shippingAddress,
    "orders": orders.map((o) => o.toJson()).toList(),
    "createdEmpUserId": createdEmpUserId,
    "orderReferencedBy": orderReferencedBy,
  };
}

