class FastagListResponse {
  final bool success;
  final String message;
  final List<FastagItem> data;
  final int totalCount;

  FastagListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
  });

  factory FastagListResponse.fromJson(Map<String, dynamic> json) {
    final innerData = json['data']['data'] as List? ?? [];
    return FastagListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: innerData.map((e) => FastagItem.fromJson(e)).toList(),
      totalCount: json['data']['totalCount'] ?? 0,
    );
  }
}

class FastagItem {
  final int id;
  final String vehicleNo;
  final String balance;
  final int orderStatus;
  final String createdAt;
  final String? rcFrontPage;
  final String? rcBackPage;

  FastagItem({
    required this.id,
    required this.vehicleNo,
    required this.balance,
    required this.orderStatus,
    required this.createdAt,
    this.rcFrontPage,
    this.rcBackPage,
  });

  factory FastagItem.fromJson(Map<String, dynamic> json) {
    return FastagItem(
      id: json['id'],
      vehicleNo: json['vehicleNo'] ?? '',
      balance: json['balance'] ?? '0.00',
      orderStatus: json['orderStatus'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      rcFrontPage: json['rcFrontPage'],
      rcBackPage: json['rcBackPage'],
    );
  }
}
