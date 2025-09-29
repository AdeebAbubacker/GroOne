class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String language;
  final MessageType messageType;
  bool isPlaying;
  bool reported; // New field for tracking reported messages
  final LoadData? loadData; // New field for load data from chat responses

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.language,
    this.messageType = MessageType.text,
    this.isPlaying = false,
    this.reported = false, // Default to false
    this.loadData, // Optional load data
  });

  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
    String? language,
    MessageType? messageType,
    bool? isPlaying,
    bool? reported, // Add reported to copyWith
    LoadData? loadData, // Add loadData to copyWith
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      messageType: messageType ?? this.messageType,
      isPlaying: isPlaying ?? this.isPlaying, // Include isPlaying field
      reported: reported ?? this.reported, // Copy reported field
      loadData: loadData ?? this.loadData, // Copy loadData field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'language': language,
      'messageType': messageType.toString(),
      'isPlaying': isPlaying, // Include isPlaying field
      'reported': reported, // Include reported field
      'loadData': loadData?.toJson(), // Include loadData field
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      language: json['language'],
      messageType: MessageType.values.firstWhere(
        (type) => type.toString() == json['messageType'],
        orElse: () => MessageType.text,
      ),
      isPlaying: json['isPlaying'] ?? false, // Parse isPlaying field with default
      reported: json['reported'] ?? false, // Parse reported field with default
      loadData: json['loadData'] != null ? LoadData.fromJson(json['loadData']) : null, // Parse loadData field
    );
  }
}

enum MessageType {
  text,
  voice,
}

enum ChatLanguage {
  english('en', 'English'),
  hindi('hi', 'हिंदी'),
  tamil('ta', 'தமிழ்');

  const ChatLanguage(this.code, this.displayName);
  
  final String code;
  final String displayName;

  static ChatLanguage fromCode(String code) {
    return ChatLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => ChatLanguage.english,
    );
  }
}

/// Load data extracted from chat responses for filtering loads
class LoadData {
  final String? source;
  final String? destination;
  final String? commodity;
  final String? truckType;
  final double? weight;
  final String? pickupDate;
  final String? deliveryDate;
  final int? routeId; // Route ID for direct filtering

  const LoadData({
    this.source,
    this.destination,
    this.commodity,
    this.truckType,
    this.weight,
    this.pickupDate,
    this.deliveryDate,
    this.routeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'destination': destination,
      'commodity': commodity,
      'truckType': truckType,
      'weight': weight,
      'pickupDate': pickupDate,
      'deliveryDate': deliveryDate,
      'routeId': routeId,
    };
  }

  factory LoadData.fromJson(Map<String, dynamic> json) {
    return LoadData(
      source: json['source'],
      destination: json['destination'],
      commodity: json['commodity'],
      truckType: json['truckType'],
      weight: json['weight']?.toDouble(),
      pickupDate: json['pickupDate'],
      deliveryDate: json['deliveryDate'],
      routeId: json['routeId'],
    );
  }

  LoadData copyWith({
    String? source,
    String? destination,
    String? commodity,
    String? truckType,
    double? weight,
    String? pickupDate,
    String? deliveryDate,
    int? routeId,
  }) {
    return LoadData(
      source: source ?? this.source,
      destination: destination ?? this.destination,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      weight: weight ?? this.weight,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      routeId: routeId ?? this.routeId,
    );
  }
}
