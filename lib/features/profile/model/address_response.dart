class PaginatedAddressList {
  final List<CustomerAddress> addresses;
  final int total;
  final PaginationInfo? pageMeta;

  PaginatedAddressList({
    required this.addresses,
    required this.total,
    required this.pageMeta,
  });

  factory PaginatedAddressList.fromJson(Map<String, dynamic> json) {
    return PaginatedAddressList(
      addresses: json["data"] == null
          ? []
          : List<CustomerAddress>.from(
          json["data"].map((x) => CustomerAddress.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null
          ? null
          : PaginationInfo.fromJson(json["pageMeta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": addresses.map((x) => x.toJson()).toList(),
    "total": total,
    "pageMeta": pageMeta?.toJson(),
  };


  PaginatedAddressList copyWith({
    List<CustomerAddress>? addresses,
    int? total,
    PaginationInfo? pageMeta,
  }) {
    return PaginatedAddressList(
      addresses: addresses ?? this.addresses,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }
}

class CustomerAddress {
  final String preferedAddressId;
  final String customerId;
  final String addrName;
  final String addr;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  final String addrType;
  final String country;
  final dynamic gstIn;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  CustomerAddress({
    required this.preferedAddressId,
    required this.customerId,
    required this.addrName,
    required this.addr,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefault,
    required this.addrType,
    required this.country,
    required this.gstIn,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      preferedAddressId: json["preferedAddressId"] ?? "",
      customerId: json["customerId"] ?? "",
      addrName: json["addrName"] ?? "",
      addr: json["addr"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      isDefault: json["isDefault"] ?? false,
      addrType: json["addrType"] ?? "",
      country: json["country"] ?? "",
      gstIn: json["gstIn"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "preferedAddressId": preferedAddressId,
    "customerId": customerId,
    "addrName": addrName,
    "addr": addr,
    "city": city,
    "state": state,
    "pincode": pincode,
    "isDefault": isDefault,
    "addrType": addrType,
    "country": country,
    "gstIn": gstIn,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class PaginationInfo {
  PaginationInfo({
    required this.page,
    required this.pageCount,
    required this.nextPage,
    required this.pageSize,
    required this.total,
  });

  final int page;
  final int pageCount;
  final dynamic nextPage;
  final int pageSize;
  final int total;

  PaginationInfo copyWith({
    int? page,
    int? pageCount,
    dynamic nextPage,
    int? pageSize,
    int? total,
  }) {
    return PaginationInfo(
      page: page ?? this.page,
      pageCount: pageCount ?? this.pageCount,
      nextPage: nextPage ?? this.nextPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
    );
  }

  factory PaginationInfo.fromJson(Map<String, dynamic> json){
    return PaginationInfo(
      page: json["page"] ?? 0,
      pageCount: json["pageCount"] ?? 0,
      nextPage: json["nextPage"],
      pageSize: json["pageSize"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "page": page,
        "pageCount": pageCount,
        "nextPage": nextPage,
        "pageSize": pageSize,
        "total": total,
      };

}