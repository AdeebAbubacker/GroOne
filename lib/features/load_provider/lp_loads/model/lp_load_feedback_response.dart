class LpLoadFeedbackResponse {
  LpLoadFeedbackResponse({
    required this.message,
    required this.data,
  });

  final String message;
  final Data? data;

  LpLoadFeedbackResponse copyWith({
    String? message,
    Data? data,
  }) {
    return LpLoadFeedbackResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpLoadFeedbackResponse.fromJson(Map<String, dynamic> json){
    return LpLoadFeedbackResponse(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.loadId,
    required this.loadSeriesId,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.consignmentWeight,
    required this.notes,
    required this.loadStatusId,
    required this.consigneeId,
  });

  final String loadId;
  final String loadSeriesId;
  final String customerId;
  final int commodityId;
  final int truckTypeId;
  final int consignmentWeight;
  final String notes;
  final int loadStatusId;
  final int consigneeId;

  Data copyWith({
    String? loadId,
    String? loadSeriesId,
    String? customerId,
    int? commodityId,
    int? truckTypeId,
    int? consignmentWeight,
    String? notes,
    int? loadStatusId,
    int? consigneeId,
  }) {
    return Data(
      loadId: loadId ?? this.loadId,
      loadSeriesId: loadSeriesId ?? this.loadSeriesId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      notes: notes ?? this.notes,
      loadStatusId: loadStatusId ?? this.loadStatusId,
      consigneeId: consigneeId ?? this.consigneeId,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      loadId: json["loadId"] ?? "",
      loadSeriesId: json["loadSeriesId"] ?? "",
      customerId: json["customerId"] ?? "",
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      consignmentWeight: json["consignmentWeight"] ?? 0,
      notes: json["notes"] ?? "",
      loadStatusId: json["loadStatusId"] ?? 0,
      consigneeId: json["consigneeId"] ?? 0,
    );
  }

}
