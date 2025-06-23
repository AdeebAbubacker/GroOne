
class ChoosePreferenceModel {
  final String? make;
  final String? model;
  final String? tankType;
  final String? engine;
  final String? deviceType;

  const ChoosePreferenceModel({
    this.make,
    this.model,
    this.tankType,
    this.engine,
    this.deviceType,
  });

  factory ChoosePreferenceModel.fromMap(Map<String, String?> map) {
    return ChoosePreferenceModel(
      make: map['make'],
      model: map['model'],
      tankType: map['tankType'],
      engine: map['engine'],
      deviceType: map['deviceType'],
    );
  }

  Map<String, String?> toMap() {
    return {
      'make': make,
      'model': model,
      'tankType': tankType,
      'engine': engine,
      'deviceType': deviceType,
    };
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    
    if (make != null && make!.isNotEmpty) {
      params['vehicle_make'] = make!;
    }
    if (model != null && model!.isNotEmpty) {
      params['vehicle_model'] = model!;
    }
    if (tankType != null && tankType!.isNotEmpty) {
      params['vehicle_tank_type'] = tankType!;
    }
    if (engine != null && engine!.isNotEmpty) {
      params['vehicle_engine'] = engine!;
    }
    if (deviceType != null && deviceType!.isNotEmpty) {
      params['vehicle_device_type'] = deviceType!;
    }
    
    return params;
  }


  bool get hasPreferences {
    return make != null || 
           model != null || 
           tankType != null || 
           engine != null || 
           deviceType != null;
  }


  ChoosePreferenceModel copyWith({
    String? make,
    String? model,
    String? tankType,
    String? engine,
    String? deviceType,
  }) {
    return ChoosePreferenceModel(
      make: make ?? this.make,
      model: model ?? this.model,
      tankType: tankType ?? this.tankType,
      engine: engine ?? this.engine,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChoosePreferenceModel &&
        other.make == make &&
        other.model == model &&
        other.tankType == tankType &&
        other.engine == engine &&
        other.deviceType == deviceType;
  }

  @override
  int get hashCode {
    return make.hashCode ^
        model.hashCode ^
        tankType.hashCode ^
        engine.hashCode ^
        deviceType.hashCode;
  }

  @override
  String toString() {
    return 'KavachPreferenceModel(make: $make, model: $model, tankType: $tankType, engine: $engine, deviceType: $deviceType)';
  }
} 