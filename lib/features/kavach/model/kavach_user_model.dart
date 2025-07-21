class KavachUserModel {
  final int empId;
  final String empCode;
  final String mobileNumber;
  final String email;
  final String userName;
  final int status;
  final List<AppAccessInfo> appAccess;
  final List<RoleInfo> freightRole;
  final List<RoleInfo> fleetRole;

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
      appAccess: (json['AppAccess'] as List<dynamic>?)
          ?.map((item) => AppAccessInfo.fromJson(item))
          .toList() ?? [],
      freightRole: (json['FreightRole'] as List<dynamic>?)
          ?.map((item) => RoleInfo.fromJson(item))
          .toList() ?? [],
      fleetRole: (json['FleetRole'] as List<dynamic>?)
          ?.map((item) => RoleInfo.fromJson(item))
          .toList() ?? [],
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
      'AppAccess': appAccess.map((item) => item.toJson()).toList(),
      'FreightRole': freightRole.map((item) => item.toJson()).toList(),
      'FleetRole': fleetRole.map((item) => item.toJson()).toList(),
    };
  }

  // Get display name for referral code (userName + empCode)
  String get displayName => '$userName $empCode';
}

class AppAccessInfo {
  final String appGroupId;
  final String appGroupName;

  AppAccessInfo({
    required this.appGroupId,
    required this.appGroupName,
  });

  factory AppAccessInfo.fromJson(Map<String, dynamic> json) {
    return AppAccessInfo(
      appGroupId: json['appGroupId'] ?? '',
      appGroupName: json['appGroupName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appGroupId': appGroupId,
      'appGroupName': appGroupName,
    };
  }
}

class RoleInfo {
  final String roleId;
  final String roleName;

  RoleInfo({
    required this.roleId,
    required this.roleName,
  });

  factory RoleInfo.fromJson(Map<String, dynamic> json) {
    return RoleInfo(
      roleId: json['roleId'] ?? '',
      roleName: json['roleName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'roleName': roleName,
    };
  }
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