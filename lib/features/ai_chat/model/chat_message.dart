class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String language;
  final MessageType messageType;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.language,
    this.messageType = MessageType.text,
  });

  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
    String? language,
    MessageType? messageType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      messageType: messageType ?? this.messageType,
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
