class GpsOrderListResponse {
  final bool success;
  final String message;
  final GpsOrderListData data;
  final int statusCode;

  GpsOrderListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory GpsOrderListResponse.fromJson(Map<String, dynamic> json) {
    return GpsOrderListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: GpsOrderListData.fromJson(json['data'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class GpsOrderListData {
  final List<GpsOrderItem> rows;
  final GpsOrderListMeta meta;

  GpsOrderListData({
    required this.rows,
    required this.meta,
  });

  factory GpsOrderListData.fromJson(Map<String, dynamic> json) {
    return GpsOrderListData(
      rows: (json['rows'] as List<dynamic>?)
              ?.map((item) => GpsOrderItem.fromJson(item))
              .toList() ??
          [],
      meta: GpsOrderListMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class GpsOrderItem {
  final String id;
  final String customerName;
  final String customerMembershipId;
  final String orderDate;
  final String orderUniqueId;
  final String orderAmount;
  final String personInCharge;
  final String shippingContactNumber;
  final String billType;
  final String orderStatusId;
  final String createdAt;
  final String? invoiceUrlPath;
  final String orderReferencedBy;
  final List<GpsOrderLineItem> lineItems;
  final GpsOrderAddress billingAddress;
  final GpsOrderAddress shippingAddress;
  final List<GpsOrderStatusHistory> statusHistory;
  final String installationContactPerson;
  final String installationContactPersonNumber;
  final int productCount;
  final double totalGst;
  final double price;
  final double totalPrice;
  final String? invoiceUrlPath2;

  GpsOrderItem({
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
    this.invoiceUrlPath2,
  });

  factory GpsOrderItem.fromJson(Map<String, dynamic> json) {
    return GpsOrderItem(
      id: json['id']?.toString() ?? '',
      customerName: json['customer_name'] ?? '',
      customerMembershipId: json['customer_membership_id'] ?? '',
      orderDate: json['order_date'] ?? '',
      orderUniqueId: json['order_unique_id'] ?? '',
      orderAmount: json['order_amount'] ?? '',
      personInCharge: json['person_in_charge'] ?? '',
      shippingContactNumber: json['shipping_contact_number'] ?? '',
      billType: json['bill_type'] ?? '',
      orderStatusId: json['order_status_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      invoiceUrlPath: json['invoice_url_path'],
      orderReferencedBy: json['order_referenced_by'] ?? '',
      lineItems: (json['lineItems'] as List<dynamic>?)
              ?.map((item) => GpsOrderLineItem.fromJson(item))
              .toList() ??
          [],
      billingAddress: GpsOrderAddress.fromJson(json['billing_address'] ?? {}),
      shippingAddress: GpsOrderAddress.fromJson(json['shipping_address'] ?? {}),
      statusHistory: (json['statusHistory'] as List<dynamic>?)
              ?.map((item) => GpsOrderStatusHistory.fromJson(item))
              .toList() ??
          [],
      installationContactPerson: json['installationContactPerson'] ?? '',
      installationContactPersonNumber: json['installationContactPersonNumber'] ?? '',
      productCount: json['productCount'] ?? 0,
      totalGst: (json['totalGst'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      invoiceUrlPath2: json['invoiceUrlPath'],
    );
  }

  // Helper method to get the current status
  String get currentStatus {
    if (statusHistory.isNotEmpty) {
      return statusHistory.first.orderStatus.statusLabel;
    }
    return 'Unknown';
  }

  // Helper method to get product names
  String get productNames {
    return lineItems.map((item) => item.product.name).join(', ');
  }
}

class GpsOrderVehicle {
  final String vehicleNumber;
  final String? deviceUniqueNumber;
  final String? devicePhoneNumber;

  GpsOrderVehicle({
    required this.vehicleNumber,
    this.deviceUniqueNumber,
    this.devicePhoneNumber,
  });

  factory GpsOrderVehicle.fromJson(Map<String, dynamic> json) {
    return GpsOrderVehicle(
      vehicleNumber: json['vehicle_number'] ?? '',
      deviceUniqueNumber: json['device_unique_number'],
      devicePhoneNumber: json['device_phone_number'],
    );
  }
}

class GpsOrderLineItem {
  final String id;
  final String itemType;
  final int quantity;
  final String unitPrice;
  final String totalPrice;
  final String productId;
  final String? serviceId;
  final String totalGstAmt;
  final GpsOrderProduct product;
  final dynamic service;
  final List<GpsOrderVehicle> vehicles;

  GpsOrderLineItem({
    required this.id,
    required this.itemType,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.productId,
    this.serviceId,
    required this.totalGstAmt,
    required this.product,
    this.service,
    required this.vehicles,
  });

  factory GpsOrderLineItem.fromJson(Map<String, dynamic> json) {
    return GpsOrderLineItem(
      id: json['id']?.toString() ?? '',
      itemType: json['item_type'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? '',
      totalPrice: json['total_price'] ?? '',
      productId: json['product_id']?.toString() ?? '',
      serviceId: json['service_id']?.toString(),
      totalGstAmt: json['total_gst_amt'] ?? '',
      product: GpsOrderProduct.fromJson(json['product'] ?? {}),
      service: json['service'],
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((e) => GpsOrderVehicle.fromJson(e))
          .toList() ?? [],
    );
  }
}

class GpsOrderProduct {
  final String name;
  final String part;
  final String fileKey;

  GpsOrderProduct({
    required this.name,
    required this.part,
    required this.fileKey,
  });

  factory GpsOrderProduct.fromJson(Map<String, dynamic> json) {
    return GpsOrderProduct(
      name: json['name'] ?? '',
      part: json['part'] ?? '',
      fileKey: json['file_key'] ?? '',
    );
  }
}

class GpsOrderAddress {
  final String addressType;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String gstId;
  final String? contactPerson;
  final String? contactNumber;

  GpsOrderAddress({
    required this.addressType,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.gstId,
    this.contactPerson,
    this.contactNumber,
  });

  factory GpsOrderAddress.fromJson(Map<String, dynamic> json) {
    return GpsOrderAddress(
      addressType: json['address_type'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      country: json['country'] ?? '',
      gstId: json['gst_id'] ?? '',
      contactPerson: json['contact_person'],
      contactNumber: json['contact_number'],
    );
  }
}

class GpsOrderStatusHistory {
  final int statusId;
  final String remarks;
  final String createdAt;
  final GpsOrderStatus orderStatus;

  GpsOrderStatusHistory({
    required this.statusId,
    required this.remarks,
    required this.createdAt,
    required this.orderStatus,
  });

  factory GpsOrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return GpsOrderStatusHistory(
      statusId: json['status_id'] ?? 0,
      remarks: json['remarks'] ?? '',
      createdAt: json['created_at'] ?? '',
      orderStatus: GpsOrderStatus.fromJson(json['orderStatus'] ?? {}),
    );
  }
}

class GpsOrderStatus {
  final String statusLabel;
  final List<String> statusDescription;

  GpsOrderStatus({
    required this.statusLabel,
    required this.statusDescription,
  });

  factory GpsOrderStatus.fromJson(Map<String, dynamic> json) {
    return GpsOrderStatus(
      statusLabel: json['status_label'] ?? '',
      statusDescription: (json['status_description'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }
}

class GpsOrderListMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  GpsOrderListMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory GpsOrderListMeta.fromJson(Map<String, dynamic> json) {
    return GpsOrderListMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
} 