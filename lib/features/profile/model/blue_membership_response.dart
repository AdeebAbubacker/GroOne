class BlueMemberShipResponse {
  BlueMemberShipResponse({
    required this.message,
    required this.data,
  });

  final String message;
  final List<Datum> data;

  BlueMemberShipResponse copyWith({
    String? message,
    List<Datum>? data,
  }) {
    return BlueMemberShipResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory BlueMemberShipResponse.fromJson(Map<String, dynamic> json){
    return BlueMemberShipResponse(
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.iconLink,
    required this.sortOrder,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String description;
  final String iconName;
  final dynamic iconLink;
  final int sortOrder;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum copyWith({
    int? id,
    String? title,
    String? description,
    String? iconName,
    dynamic? iconLink,
    int? sortOrder,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Datum(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      iconLink: iconLink ?? this.iconLink,
      sortOrder: sortOrder ?? this.sortOrder,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      iconName: json["icon_name"] ?? "",
      iconLink: json["icon_link"],
      sortOrder: json["sort_order"] ?? 0,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "icon_name": iconName,
    "icon_link": iconLink,
    "sort_order": sortOrder,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
