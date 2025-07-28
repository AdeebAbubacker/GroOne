class KavachOrderListMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  KavachOrderListMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory KavachOrderListMeta.fromJson(Map<String, dynamic> json) {
    return KavachOrderListMeta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class KavachOrderListResponse {
  final List<KavachOrderListOrderItem> orders;
  final KavachOrderListMeta meta;

  KavachOrderListResponse({required this.orders, required this.meta});

  factory KavachOrderListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return KavachOrderListResponse(
      orders: (data['rows'] as List)
          .map((e) => KavachOrderListOrderItem.fromJson(e))
          .toList(),
      meta: KavachOrderListMeta.fromJson(data['meta']),
    );
  }
}

class KavachOrderListProduct {
  final String name;
  final String part;
  final String fileKey;

  KavachOrderListProduct({
    required this.name,
    required this.part,
    required this.fileKey,
  });

  factory KavachOrderListProduct.fromJson(Map<String, dynamic> json) {
    return KavachOrderListProduct(
      name: json['name'] ?? '',
      part: json['part'] ?? '',
      fileKey: json['file_key'] ?? '',
    );
  }
}

class KavachOrderListService {
  KavachOrderListService();

  factory KavachOrderListService.fromJson(Map<String, dynamic> json) {
    return KavachOrderListService();
  }
}

class KavachOrderListVehicle {
  final String vehicleNumber;
  final String? deviceUniqueNumber;
  final String? devicePhoneNumber;

  KavachOrderListVehicle({
    required this.vehicleNumber,
    this.deviceUniqueNumber,
    this.devicePhoneNumber,
  });

  factory KavachOrderListVehicle.fromJson(Map<String, dynamic> json) {
    return KavachOrderListVehicle(
      vehicleNumber: json['vehicle_number'] ?? '',
      deviceUniqueNumber: json['device_unique_number'],
      devicePhoneNumber: json['device_phone_number'],
    );
  }
}

class KavachOrderListItem {
  final String id;
  final String itemType;
  final int quantity;
  final String unitPrice;
  final String totalPrice;
  final String? productId;
  final String? serviceId;
  final String totalGstAmt;
  final KavachOrderListProduct? product;
  final KavachOrderListService? service;
  final List<KavachOrderListVehicle> vehicles;

  KavachOrderListItem({
    required this.id,
    required this.itemType,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.productId,
    this.serviceId,
    required this.totalGstAmt,
    this.product,
    this.service,
    required this.vehicles,
  });

  factory KavachOrderListItem.fromJson(Map<String, dynamic> json) {
    return KavachOrderListItem(
      id: json['id'],
      itemType: json['item_type'],
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      productId: json['product_id'],
      serviceId: json['service_id'],
      totalGstAmt: json['total_gst_amt'],
      product: json['product'] != null
          ? KavachOrderListProduct.fromJson(json['product'])
          : null,
      service: json['service'] != null
          ? KavachOrderListService.fromJson(json['service'])
          : null,
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((e) => KavachOrderListVehicle.fromJson(e))
          .toList() ?? [],
    );
  }
}

class KavachOrderListStatusHistory {
  final int statusId;
  final String remarks;
  final DateTime createdAt;
  final String statusLabel;
  final List<String> statusDescription;

  KavachOrderListStatusHistory({
    required this.statusId,
    required this.remarks,
    required this.createdAt,
    required this.statusLabel,
    required this.statusDescription,
  });

  factory KavachOrderListStatusHistory.fromJson(Map<String, dynamic> json) {
    return KavachOrderListStatusHistory(
      statusId: json['status_id'],
      remarks: json['remarks'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      statusLabel: json['orderStatus']?['status_label'] ?? '',
      statusDescription: (json['orderStatus']?['status_description'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}

class KavachOrderListAddress {
  final String addressType;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String gstId;
  final String contactPerson;
  final String contactNumber;

  KavachOrderListAddress({
    required this.addressType,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.gstId,
    required this.contactPerson,
    required this.contactNumber,
  });

  factory KavachOrderListAddress.fromJson(Map<String, dynamic> json) {
    return KavachOrderListAddress(
      addressType: json['address_type'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
      gstId: json['gst_id'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      contactNumber: json['contact_number'] ?? '',
    );
  }
}

class KavachOrderListOrderItem {
  final String id;
  final String customerName;
  final String customerMembershipId;
  final DateTime orderDate;
  final String orderUniqueId;
  final String orderAmount;
  final String personInCharge;
  final String shippingContactNumber;
  final String billType;
  final String orderStatusId;
  final DateTime createdAt;
  final String? invoiceUrlPath;
  final String orderReferencedBy;
  final List<KavachOrderListItem> lineItems;
  final KavachOrderListAddress billingAddress;
  final KavachOrderListAddress shippingAddress;
  final List<KavachOrderListStatusHistory> statusHistory;
  final String installationContactPerson;
  final String installationContactPersonNumber;
  final int productCount;
  final double totalGst;
  final double price;
  final double totalPrice;

  KavachOrderListOrderItem({
    required this.id,
    required this.customerName,
    required this.customerMembershipId,
    required this.orderDate,
    required this.orderUniqueId,
    required this.orderAmount,
    required this.personInCharge,
    required this.shippingContactNumber,
    required this.billType,
    required this.orderStatusId,
    required this.createdAt,
    this.invoiceUrlPath,
    required this.orderReferencedBy,
    required this.lineItems,
    required this.billingAddress,
    required this.shippingAddress,
    required this.statusHistory,
    required this.installationContactPerson,
    required this.installationContactPersonNumber,
    required this.productCount,
    required this.totalGst,
    required this.price,
    required this.totalPrice,
  });

  factory KavachOrderListOrderItem.fromJson(Map<String, dynamic> json) {
    return KavachOrderListOrderItem(
      id: json['id'],
      customerName: json['customer_name'],
      customerMembershipId: json['customer_membership_id'],
      orderDate: DateTime.parse(json['order_date']),
      orderUniqueId: json['order_unique_id'],
      orderAmount: json['order_amount'],
      personInCharge: json['person_in_charge'],
      shippingContactNumber: json['shipping_contact_number'],
      billType: json['bill_type'],
      orderStatusId: json['order_status_id'],
      createdAt: DateTime.parse(json['created_at']),
      invoiceUrlPath: json['invoice_url_path'],
      orderReferencedBy: json['order_referenced_by'] ?? '',
      lineItems: (json['lineItems'] as List)
          .map((e) => KavachOrderListItem.fromJson(e))
          .toList(),
      billingAddress: KavachOrderListAddress.fromJson(json['billing_address']),
      shippingAddress:
      KavachOrderListAddress.fromJson(json['shipping_address']),
      statusHistory: (json['statusHistory'] as List)
          .map((e) => KavachOrderListStatusHistory.fromJson(e))
          .toList(),
      installationContactPerson: json['installationContactPerson'] ?? '',
      installationContactPersonNumber:
      json['installationContactPersonNumber'] ?? '',
      productCount: json['productCount'],
      totalGst: (json['totalGst'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}





///old
// class KavachOrderListMeta {
//   final int total;
//   final int page;
//   final int limit;
//   final int totalPages;
//
//   KavachOrderListMeta({
//     required this.total,
//     required this.page,
//     required this.limit,
//     required this.totalPages,
//   });
//
//   factory KavachOrderListMeta.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListMeta(
//       total: json['total'],
//       page: json['page'],
//       limit: json['limit'],
//       totalPages: json['totalPages'],
//     );
//   }
// }
//
// class KavachOrderListResponse {
//   final List<KavachOrderListOrderItem> orders;
//   final KavachOrderListMeta meta;
//
//   KavachOrderListResponse({required this.orders, required this.meta});
//
//   factory KavachOrderListResponse.fromJson(Map<String, dynamic> json) {
//     final data = json['data'];
//     return KavachOrderListResponse(
//       orders: (data['rows'] as List)
//           .map((e) => KavachOrderListOrderItem.fromJson(e))
//           .toList(),
//       meta: KavachOrderListMeta.fromJson(data['meta']),
//     );
//   }
// }
//
// class KavachOrderListProduct {
//   final String name;
//   final String part;
//   final String fileKey;
//
//   KavachOrderListProduct({
//     required this.name,
//     required this.part,
//     required this.fileKey,
//   });
//
//   factory KavachOrderListProduct.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListProduct(
//       name: json['name'],
//       part: json['part'],
//       fileKey: json['file_key'],
//     );
//   }
// }
//
// class KavachOrderListService {
//   // Assuming Service can be null or have a similar structure to Product if not null
//   KavachOrderListService();
//
//   factory KavachOrderListService.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListService();
//   }
// }
//
// class KavachOrderListItem {
//   final String id;
//   final String itemType;
//   final int quantity;
//   final String unitPrice;
//   final String totalPrice;
//   final String? productId; // Can be null
//   final String? serviceId; // Can be null
//   final String totalGstAmt;
//   final KavachOrderListProduct? product; // Can be null
//   final KavachOrderListService? service; // Can be null
//
//   KavachOrderListItem({
//     required this.id,
//     required this.itemType,
//     required this.quantity,
//     required this.unitPrice,
//     required this.totalPrice,
//     this.productId,
//     this.serviceId,
//     required this.totalGstAmt,
//     this.product,
//     this.service,
//   });
//
//   factory KavachOrderListItem.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListItem(
//       id: json['id'],
//       itemType: json['item_type'],
//       quantity: json['quantity'],
//       unitPrice: json['unit_price'],
//       totalPrice: json['total_price'],
//       productId: json['product_id'],
//       serviceId: json['service_id'],
//       totalGstAmt: json['total_gst_amt'],
//       product: json['product'] != null ? KavachOrderListProduct.fromJson(json['product']) : null,
//       service: json['service'] != null ? KavachOrderListService.fromJson(json['service']) : null,
//     );
//   }
// }
//
// class KavachOrderListStatusHistory {
//   final int statusId;
//   final String remarks;
//   final DateTime createdAt;
//   final String statusLabel;
//
//   KavachOrderListStatusHistory({
//     required this.statusId,
//     required this.remarks,
//     required this.createdAt,
//     required this.statusLabel,
//   });
//
//   factory KavachOrderListStatusHistory.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListStatusHistory(
//       statusId: json['status_id'],
//       remarks: json['remarks'] ?? '',
//       createdAt: DateTime.parse(json['created_at']),
//         statusLabel: json['orderStatus']?['status_label'] ?? '',
//     );
//   }
// }
//
// class KavachOrderListAddress {
//   final String addressType;
//   final String addressLine1;
//   final String addressLine2;
//   final String city;
//   final String state;
//   final String postalCode;
//   final String country;
//   final String gstId;
//   final String contactPerson;
//   final String contactNumber;
//
//   KavachOrderListAddress({
//     required this.addressType,
//     required this.addressLine1,
//     required this.addressLine2,
//     required this.city,
//     required this.state,
//     required this.postalCode,
//     required this.country,
//     required this.gstId,
//     required this.contactPerson,
//     required this.contactNumber,
//   });
//
//   factory KavachOrderListAddress.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListAddress(
//       addressType: json['address_type'],
//       addressLine1: json['address_line1'],
//       addressLine2: json['address_line2'],
//       city: json['city'],
//       state: json['state'],
//       postalCode: json['postal_code'],
//       country: json['country'],
//       gstId: json['gst_id']??'',
//       contactPerson: json['contact_person']??'',
//       contactNumber: json['contact_number']??'',
//     );
//   }
// }

// class KavachOrderListOrderItem {
//   final String id;
//   final String customerName;
//   final String customerMembershipId;
//   final DateTime orderDate;
//   final String orderUniqueId;
//   final String orderAmount;
//   final String personInCharge;
//   final String shippingContactNumber;
//   final String billType;
//   final String orderStatusId;
//   final DateTime createdAt;
//   final String? invoiceUrlPath; // Can be null
//   final List<KavachOrderListItem> lineItems;
//   final KavachOrderListAddress billingAddress;
//   final KavachOrderListAddress shippingAddress;
//   final List<KavachOrderListStatusHistory> statusHistory;
//   final String installationContactPerson;
//   final String installationContactPersonNumber;
//   final int productCount;
//   final double totalGst;
//   final double price; // Changed to double
//   final double totalPrice;
//   final String? invoiceUrlPathAlt;
//
//   KavachOrderListOrderItem({
//     required this.id,
//     required this.customerName,
//     required this.customerMembershipId,
//     required this.orderDate,
//     required this.orderUniqueId,
//     required this.orderAmount,
//     required this.personInCharge,
//     required this.shippingContactNumber,
//     required this.billType,
//     required this.orderStatusId,
//     required this.createdAt,
//     this.invoiceUrlPath,
//     required this.lineItems,
//     required this.billingAddress,
//     required this.shippingAddress,
//     required this.statusHistory,
//     required this.installationContactPerson,
//     required this.installationContactPersonNumber,
//     required this.productCount,
//     required this.totalGst,
//     required this.price,
//     required this.totalPrice,
//     this.invoiceUrlPathAlt,
//   });
//
//   factory KavachOrderListOrderItem.fromJson(Map<String, dynamic> json) {
//     return KavachOrderListOrderItem(
//       id: json['id'],
//       customerName: json['customer_name'],
//       customerMembershipId: json['customer_membership_id'],
//       orderDate: DateTime.parse(json['order_date']),
//       orderUniqueId: json['order_unique_id'],
//       orderAmount: json['order_amount'],
//       personInCharge: json['person_in_charge'],
//       shippingContactNumber: json['shipping_contact_number'],
//       billType: json['bill_type'],
//       orderStatusId: json['order_status_id'],
//       createdAt: DateTime.parse(json['created_at']),
//       invoiceUrlPath: json['invoice_url_path'],
//       lineItems: (json['lineItems'] as List)
//           .map((e) => KavachOrderListItem.fromJson(e))
//           .toList(),
//       billingAddress: KavachOrderListAddress.fromJson(json['billing_address']),
//       shippingAddress: KavachOrderListAddress.fromJson(json['shipping_address']),
//       statusHistory: (json['statusHistory'] as List)
//           .map((e) => KavachOrderListStatusHistory.fromJson(e))
//           .toList(),
//       installationContactPerson: json['installationContactPerson'],
//       installationContactPersonNumber: json['installationContactPersonNumber'],
//       productCount: json['productCount'],
//       totalGst: (json['totalGst'] as num).toDouble(),
//       // Here's the fix: explicitly convert to double
//       price: (json['price'] as num).toDouble(),
//       totalPrice: (json['totalPrice'] as num).toDouble(),
//       invoiceUrlPathAlt: json['invoiceUrlPath'],
//     );
//   }
// }