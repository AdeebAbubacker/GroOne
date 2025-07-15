class KavachUserModel {
  final int empId;
  final String empCode;
  final String mobileNumber;
  final String email;
  final String userName;
  final int status;
  final List<String> appAccess;
  final List<String> freightRole;
  final List<String> fleetRole;

  KavachUserModel({
    required this.empId,
    required this.empCode,
    required this.mobileNumber,
    required this.email,
    required this.userName,
    required this.status,
    required this.appAccess,
    required this.freightRole,
    required this.fleetRole,
  });

  factory KavachUserModel.fromJson(Map<String, dynamic> json) {
    return KavachUserModel(
      empId: json['empId'] ?? 0,
      empCode: json['empCode'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      status: json['status'] ?? 0,
      appAccess: List<String>.from(json['AppAccess'] ?? []),
      freightRole: List<String>.from(json['FreightRole'] ?? []),
      fleetRole: List<String>.from(json['FleetRole'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'empCode': empCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'userName': userName,
      'status': status,
      'AppAccess': appAccess,
      'FreightRole': freightRole,
      'FleetRole': fleetRole,
    };
  }

  // Get display name for referral code (userName + empCode)
  String get displayName => '$userName $empCode';
}

class KavachUserListResponse {
  final String message;
  final List<KavachUserModel> data;
  final PaginationInfo pagination;

  KavachUserListResponse({
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory KavachUserListResponse.fromJson(Map<String, dynamic> json) {
    return KavachUserListResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => KavachUserModel.fromJson(item))
          .toList() ?? [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationInfo {
  final int total;
  final int page;
  final int limit;

  PaginationInfo({
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
} 