import '../service/chat_api_service.dart';
import '../model/chat_message.dart';

class ChatRepository {
  final ChatApiService _apiService;

  ChatRepository(this._apiService);

  /// Send text message and get AI response
  Future<ChatMessage> sendTextMessage({
    required String message,
    required String language,
  }) async {
    try {
      print('📝 Sending text message to repository: $message'); // Debug log
      
      final response = await _apiService.sendTextMessage(
        message: message,
        language: language,
      );
      
      print('📝 Repository received response: $response'); // Debug log

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );
    } catch (e) {
      print('📝 Repository error: $e'); // Debug log
      
      // Return error message as AI response
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Sorry, I encountered an error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );
    }
  }

  /// Send voice message and get AI response
  Future<ChatMessage> sendVoiceMessage({
    required String audioFilePath,
    required String language,
  }) async {
    try {
      final response = await _apiService.sendVoiceMessage(
        audioFilePath: audioFilePath,
        language: language,
      );

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );
    } catch (e) {
      // Return error message as AI response
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Sorry, I couldn\'t process your voice message: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );
    }
  }

  /// Load chat history from API
  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final historyData = await _apiService.getChatHistory();
      
      return historyData.map((data) => ChatMessage.fromJson(data)).toList();
    } catch (e) {
      // Return empty list if failed to load history
      return [];
    }
  }
}
