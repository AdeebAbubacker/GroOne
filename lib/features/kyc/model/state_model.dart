class StateModel {
  StateModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final StateData? data;

  StateModel copyWith({
    bool? success,
    String? message,
    StateData? data,
  }) {
    return StateModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory StateModel.fromJson(Map<String, dynamic> json){
    return StateModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : StateData.fromJson(json["data"]),
    );
  }

}

class StateData {
  StateData({
    required this.success,
    required this.response,
  });

  final bool success;
  final List<String> response;

  StateData copyWith({
    bool? success,
    List<String>? response,
  }) {
    return StateData(
      success: success ?? this.success,
      response: response ?? this.response,
    );
  }

  factory StateData.fromJson(Map<String, dynamic> json){
    return StateData(
      success: json["success"] ?? false,
      response: json["response"] == null ? [] : List<String>.from(json["response"]!.map((x) => x)),
    );
  }

}
