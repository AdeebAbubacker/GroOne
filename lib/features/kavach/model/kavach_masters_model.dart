
class KavachMastersModel {
  final bool success;
  final String message;
  final KavachMastersData data;

  KavachMastersModel({
    required this.success,
    required this.message,
    required this.data,
  });


  factory KavachMastersModel.fromJson(Map<String, dynamic> json) {
    return KavachMastersModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: KavachMastersData.fromJson(json['data'] ?? {}),
    );
  }
}

class KavachMastersData {
  final List<KavachBillType> billTypes;
  final List<KavachOrderType> orderTypes;
  final List<KavachCategory> categories;
  final Map<String, KavachVehicleFilter> vehicleFilters;

  KavachMastersData({
    required this.billTypes,
    required this.orderTypes,
    required this.categories,
    required this.vehicleFilters,
  });


  factory KavachMastersData.fromJson(Map<String, dynamic> json) {
    final vehicleFiltersMap = json['vehicleFilters'] as Map<String, dynamic>? ?? {};
    final Map<String, KavachVehicleFilter> filters = {};

    vehicleFiltersMap.forEach((key, value) {
      filters[key] = KavachVehicleFilter.fromJson(value as Map<String, dynamic>);
    });

    return KavachMastersData(
      billTypes: (json['billTypes'] as List?)?.map((e) => KavachBillType.fromJson(e)).toList() ?? [],
      orderTypes: (json['orderTypes'] as List?)?.map((e) => KavachOrderType.fromJson(e)).toList() ?? [],
      categories: (json['categories'] as List?)?.map((e) => KavachCategory.fromJson(e)).toList() ?? [],
      vehicleFilters: filters,
    );
  }
}


class KavachVehicleFilter {
  final List<String> models;
  final List<String> tankType;
  final List<String> deviceType;
  final List<String> engineType;

  KavachVehicleFilter({
    required this.models,
    required this.tankType,
    required this.deviceType,
    required this.engineType,
  });


  factory KavachVehicleFilter.fromJson(Map<String, dynamic> json) {
    return KavachVehicleFilter(
      models: (json['models'] as List?)?.map((e) => e.toString()).toList() ?? [],
      tankType: (json['tank_type'] as List?)?.map((e) => e.toString()).toList() ?? [],
      deviceType: (json['device_type'] as List?)?.map((e) => e.toString()).toList() ?? [],
      engineType: (json['engine_type'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}


class KavachBillType {
  final int id;
  final String name;
  final String code;
  final int value;

  KavachBillType({
    required this.id,
    required this.name,
    required this.code,
    required this.value,
  });


  factory KavachBillType.fromJson(Map<String, dynamic> json) {
    return KavachBillType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class KavachOrderType {
  final int id;
  final String name;
  final String code;
  final int value;

  KavachOrderType({
    required this.id,
    required this.name,
    required this.code,
    required this.value,
  });

  factory KavachOrderType.fromJson(Map<String, dynamic> json) {
    return KavachOrderType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class KavachCategory {
  final int id;
  final String name;
  final String code;
  final int value;

  KavachCategory({
    required this.id,
    required this.name,
    required this.code,
    required this.value,
  });

  factory KavachCategory.fromJson(Map<String, dynamic> json) {
    return KavachCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}