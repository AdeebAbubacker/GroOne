class KavachVehicleDocumentUploadModel {
  KavachVehicleDocumentUploadModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  factory KavachVehicleDocumentUploadModel.fromJson(Map<String, dynamic> json){
    
    // Handle both direct response format and nested format
    Data? uploadData;
    
    if (json['url'] != null) {
      // Direct structure: {url: "...", filePath: "...", originalName: "..."}
      uploadData = Data.fromJson(json);
    } else if (json['data'] != null && json['data']['url'] != null) {
      // Nested structure: {success: true, data: {url: "..."}}
      uploadData = Data.fromJson(json['data']);
    }
    
    return KavachVehicleDocumentUploadModel(
      success: json["success"] ?? true, // Default to true if not specified
      message: json["message"] ?? "",
      data: uploadData,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.url,
    this.filePath,
    this.originalName,
    this.size,
    this.mimeType,
  });

  final String url;
  final String? filePath;
  final String? originalName;
  final int? size;
  final String? mimeType;

  factory Data.fromJson(Map<String, dynamic> json){
    try {
      return Data(
        url: json["url"]?.toString() ?? "",
        filePath: json["filePath"]?.toString(),
        originalName: json["originalName"]?.toString(),
        size: json["size"] is int ? json["size"] : int.tryParse(json["size"]?.toString() ?? '0'),
        mimeType: json["mimeType"]?.toString(),
      );
    } catch (e) {
      // Return a default data object if parsing fails
      return Data(
        url: json["url"]?.toString() ?? "",
        filePath: json["filePath"]?.toString(),
        originalName: json["originalName"]?.toString(),
        size: 0,
        mimeType: 'application/octet-stream',
      );
    }
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "filePath": filePath,
    "originalName": originalName,
    "size": size,
    "mimeType": mimeType,
  };
}
