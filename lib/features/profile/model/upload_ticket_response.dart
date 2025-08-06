class UploadTicketResponse {
  UploadTicketResponse({
    required this.url,
    required this.filePath,
    required this.originalName,
    required this.size,
    required this.mimeType,
  });

  final String url;
  final String filePath;
  final String originalName;
  final int size;
  final String mimeType;

  UploadTicketResponse copyWith({
    String? url,
    String? filePath,
    String? originalName,
    int? size,
    String? mimeType,
  }) {
    return UploadTicketResponse(
      url: url ?? this.url,
      filePath: filePath ?? this.filePath,
      originalName: originalName ?? this.originalName,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  factory UploadTicketResponse.fromJson(Map<String, dynamic> json){
    return UploadTicketResponse(
      url: json["url"] ?? "",
      filePath: json["filePath"] ?? "",
      originalName: json["originalName"] ?? "",
      size: json["size"] ?? 0,
      mimeType: json["mimeType"] ?? "",
    );
  }

}
