class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String language;
  final MessageType messageType;
  bool isPlaying;
  bool reported; // New field for tracking reported messages

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.language,
    this.messageType = MessageType.text,
    this.isPlaying = false,
    this.reported = false, // Default to false
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
