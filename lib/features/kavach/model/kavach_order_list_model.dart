class KavachOrderListItem {
  final String id;
  final String itemType;
  final int quantity;
  final String unitPrice;
  final String totalPrice;

  KavachOrderListItem({
    required this.id,
    required this.itemType,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory KavachOrderListItem.fromJson(Map<String, dynamic> json) {
    return KavachOrderListItem(
      id: json['id'],
      itemType: json['item_type'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
    );
  }
}

class KavachOrderListStatusHistory {
  final int statusId;
  final String remarks;
  final DateTime createdAt;
  final String statusLabel;

  KavachOrderListStatusHistory({
    required this.statusId,
    required this.remarks,
    required this.createdAt,
    required this.statusLabel,
  });

  factory KavachOrderListStatusHistory.fromJson(Map<String, dynamic> json) {
    return KavachOrderListStatusHistory(
      statusId: json['status_id'],
      remarks: json['remarks'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      statusLabel: json['orderStatus']['status_label'],
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
  final List<KavachOrderListItem> lineItems;
  final List<KavachOrderListStatusHistory> statusHistory;

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
    required this.lineItems,
    required this.statusHistory,
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
      lineItems: (json['lineItems'] as List)
          .map((e) => KavachOrderListItem.fromJson(e))
          .toList(),
      statusHistory: (json['statusHistory'] as List)
          .map((e) => KavachOrderListStatusHistory.fromJson(e))
          .toList(),
    );
  }
}

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
