class PincodeResponse {
  final bool success;
  final String message;
  final PincodeData? data;

  PincodeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PincodeResponse.fromJson(Map<String, dynamic> json) {
    return PincodeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PincodeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PincodeData {
  final District? district;
  final State? state;
  final Zonal? zonal;
  final Region? region;

  PincodeData({
    this.district,
    this.state,
    this.zonal,
    this.region,
  });

  factory PincodeData.fromJson(Map<String, dynamic> json) {
    return PincodeData(
      district: json['district'] != null ? District.fromJson(json['district']) : null,
      state: json['state'] != null ? State.fromJson(json['state']) : null,
      zonal: json['zonal'] != null ? Zonal.fromJson(json['zonal']) : null,
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'district': district?.toJson(),
      'state': state?.toJson(),
      'zonal': zonal?.toJson(),
      'region': region?.toJson(),
    };
  }
}

class District {
  final int id;
  final String name;

  District({
    required this.id,
    required this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class State {
  final int id;
  final String name;

  State({
    required this.id,
    required this.name,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Zonal {
  final int id;
  final String name;

  Zonal({
    required this.id,
    required this.name,
  });

  factory Zonal.fromJson(Map<String, dynamic> json) {
    return Zonal(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Region {
  final int id;
  final String name;

  Region({
    required this.id,
    required this.name,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
} 