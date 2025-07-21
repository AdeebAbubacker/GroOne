class LpCreateOrderResponse {
    LpCreateOrderResponse({
        required this.message,
        required this.orderId,
        required this.order,
    });

    final String message;
    final String orderId;
    final Order? order;

    LpCreateOrderResponse copyWith({
        String? message,
        String? orderId,
        Order? order,
    }) {
        return LpCreateOrderResponse(
            message: message ?? this.message,
            orderId: orderId ?? this.orderId,
            order: order ?? this.order,
        );
    }

    factory LpCreateOrderResponse.fromJson(Map<String, dynamic> json){ 
        return LpCreateOrderResponse(
            message: json["message"] ?? "",
            orderId: json["orderId"] ?? "",
            order: json["order"] == null ? null : Order.fromJson(json["order"]),
        );
    }

}

class Order {
    Order({
        required this.id,
        required this.loadId,
        required this.memoId,
        required this.orderId,
        required this.netFreight,
        required this.amount,
        required this.percentage,
        required this.totalPaid,
        required this.loadMargin,
        required this.loadMarginAmount,
        required this.action,
        required this.orderType,
        required this.orderStatus,
        required this.orderDate,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String id;
    final String loadId;
    final String memoId;
    final String orderId;
    final int netFreight;
    final int amount;
    final int percentage;
    final int totalPaid;
    final int loadMargin;
    final int loadMarginAmount;
    final String action;
    final String orderType;
    final String orderStatus;
    final DateTime? orderDate;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Order copyWith({
        String? id,
        String? loadId,
        String? memoId,
        String? orderId,
        int? netFreight,
        int? amount,
        int? percentage,
        int? totalPaid,
        int? loadMargin,
        int? loadMarginAmount,
        String? action,
        String? orderType,
        String? orderStatus,
        DateTime? orderDate,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return Order(
            id: id ?? this.id,
            loadId: loadId ?? this.loadId,
            memoId: memoId ?? this.memoId,
            orderId: orderId ?? this.orderId,
            netFreight: netFreight ?? this.netFreight,
            amount: amount ?? this.amount,
            percentage: percentage ?? this.percentage,
            totalPaid: totalPaid ?? this.totalPaid,
            loadMargin: loadMargin ?? this.loadMargin,
            loadMarginAmount: loadMarginAmount ?? this.loadMarginAmount,
            action: action ?? this.action,
            orderType: orderType ?? this.orderType,
            orderStatus: orderStatus ?? this.orderStatus,
            orderDate: orderDate ?? this.orderDate,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory Order.fromJson(Map<String, dynamic> json) {
  return Order(
    id: json["id"] ?? "",
    loadId: json["loadId"] ?? "",
    memoId: json["memoId"] ?? "",
    orderId: json["orderId"] ?? "",
    netFreight: (json["netFreight"] as num?)?.toInt() ?? 0,
    amount: (json["amount"] as num?)?.toInt() ?? 0,
    percentage: (json["percentage"] as num?)?.toInt() ?? 0,
    totalPaid: (json["totalPaid"] as num?)?.toInt() ?? 0,
    loadMargin: (json["loadMargin"] as num?)?.toInt() ?? 0,
    loadMarginAmount: (json["loadMarginAmount"] as num?)?.toInt() ?? 0,
    action: json["action"] ?? "",
    orderType: json["orderType"] ?? "",
    orderStatus: json["orderStatus"] ?? "",
    orderDate: DateTime.tryParse(json["orderDate"] ?? ""),
    status: (json["status"] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    deletedAt: json["deletedAt"],
  );
}

}
