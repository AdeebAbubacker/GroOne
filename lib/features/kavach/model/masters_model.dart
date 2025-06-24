
class MastersModel {
  final bool success;
  final String message;
  final MastersData data;

  MastersModel({
    required this.success,
    required this.message,
    required this.data,
  });


  factory MastersModel.fromJson(Map<String, dynamic> json) {
    return MastersModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MastersData.fromJson(json['data'] ?? {}),
    );
  }
}

class MastersData {
  final List<BillType> billTypes;
  final List<OrderType> orderTypes;
  final List<Category> categories;
  final Map<String, VehicleFilter> vehicleFilters;

  MastersData({
    required this.billTypes,
    required this.orderTypes,
    required this.categories,
    required this.vehicleFilters,
  });


  factory MastersData.fromJson(Map<String, dynamic> json) {
    final vehicleFiltersMap = json['vehicleFilters'] as Map<String, dynamic>? ?? {};
    final Map<String, VehicleFilter> filters = {};
    
    vehicleFiltersMap.forEach((key, value) {
      filters[key] = VehicleFilter.fromJson(value as Map<String, dynamic>);
    });

    return MastersData(
      billTypes: (json['billTypes'] as List?)?.map((e) => BillType.fromJson(e)).toList() ?? [],
      orderTypes: (json['orderTypes'] as List?)?.map((e) => OrderType.fromJson(e)).toList() ?? [],
      categories: (json['categories'] as List?)?.map((e) => Category.fromJson(e)).toList() ?? [],
      vehicleFilters: filters,
    );
  }
}


class VehicleFilter {
  final List<String> models;
  final List<String> tankType;
  final List<String> deviceType;
  final List<String> engineType;

  VehicleFilter({
    required this.models,
    required this.tankType,
    required this.deviceType,
    required this.engineType,
  });

 
  factory VehicleFilter.fromJson(Map<String, dynamic> json) {
    return VehicleFilter(
      models: (json['models'] as List?)?.map((e) => e.toString()).toList() ?? [],
      tankType: (json['tank_type'] as List?)?.map((e) => e.toString()).toList() ?? [],
      deviceType: (json['device_type'] as List?)?.map((e) => e.toString()).toList() ?? [],
      engineType: (json['engine_type'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}


class BillType {
  final int id;
  final String name;
  final String code;
  final int value;

  BillType({
    required this.id,
    required this.name,
    required this.code,
    required this.value,
  });


  factory BillType.fromJson(Map<String, dynamic> json) {
    return BillType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class OrderType {
  final int id;
  final String name;
  final String code;
  final int value;

  OrderType({
    required this.id,
    required this.name,
    required this.code,
    required this.value,
  });

  factory OrderType.fromJson(Map<String, dynamic> json) {
    return OrderType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String code;
  final int value;

  Category({
    required this.id,
    required this.name,
    required this.code,
    required this.value,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
    );
  }
} 