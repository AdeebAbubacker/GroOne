class PathPositionsPojo {
  List<Data>? data;
  double? fwdVariable;
  int? fwdVariable2;

  PathPositionsPojo({this.data, this.fwdVariable, this.fwdVariable2});

  PathPositionsPojo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    fwdVariable = json['fwd_variable'];
    fwdVariable2 = json['fwd_variable_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['fwd_variable'] = this.fwdVariable;
    data['fwd_variable_2'] = this.fwdVariable2;
    return data;
  }
}

class Data {
  String? timestamp;
  dynamic altitude;
  int? deviceId;
  String? deviceTime;
  dynamic distance;
  dynamic engine2;
  dynamic engineHours;
  dynamic extPower;
  String? fixTime;
  String? ignition;
  double? latitude;
  String? location;
  double? longitude;
  String? motion;
  String? serverTime;
  double? speed;
  String? stopTime;
  String? temperature;
  dynamic totalDistance;

  Data(
      {this.timestamp,
        this.altitude,
        this.deviceId,
        this.deviceTime,
        this.distance,
        this.engine2,
        this.engineHours,
        this.extPower,
        this.fixTime,
        this.ignition,
        this.latitude,
        this.location,
        this.longitude,
        this.motion,
        this.serverTime,
        this.speed,
        this.stopTime,
        this.temperature,
        this.totalDistance});

  Data.fromJson(Map<String, dynamic> json) {
    timestamp = json['@timestamp'];
    altitude = json['altitude'];
    deviceId = json['device_id'];
    deviceTime = json['device_time'];
    distance = json['distance'];
    engine2 = json['engine2'];
    engineHours = json['engine_hours'];
    extPower = json['ext_power'];
    fixTime = json['fix_time'];
    ignition = json['ignition'];
    latitude = json['latitude'];
    location = json['location'];
    longitude = json['longitude'];
    motion = json['motion'];
    serverTime = json['server_time'];
    speed = json['speed'];
    stopTime = json['stop_time'];
    temperature = json['temperature'];
    totalDistance = json['total_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@timestamp'] = this.timestamp;
    data['altitude'] = this.altitude;
    data['device_id'] = this.deviceId;
    data['device_time'] = this.deviceTime;
    data['distance'] = this.distance;
    data['engine2'] = this.engine2;
    data['engine_hours'] = this.engineHours;
    data['ext_power'] = this.extPower;
    data['fix_time'] = this.fixTime;
    data['ignition'] = this.ignition;
    data['latitude'] = this.latitude;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['motion'] = this.motion;
    data['server_time'] = this.serverTime;
    data['speed'] = this.speed;
    data['stop_time'] = this.stopTime;
    data['temperature'] = this.temperature;
    data['total_distance'] = this.totalDistance;
    return data;
  }
}

