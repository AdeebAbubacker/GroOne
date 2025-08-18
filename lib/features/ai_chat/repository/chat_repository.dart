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

  /// Load chat history from API with pagination
  Future<Map<String, dynamic>> loadChatHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      print('📚 Repository: Loading chat history page $page...'); // Debug log
      final historyData = await _apiService.getChatHistory(
        page: page,
        pageSize: pageSize,
      );
      
      print('📚 Repository: Received history data: $historyData'); // Debug log
      return historyData;
    } catch (e) {
      print('📚 Repository: Error loading chat history: $e'); // Debug log
      rethrow;
    }
  }

  /// Synthesize text to speech
  Future<String> synthesizeTextToSpeech({
    required String text,
    required String language,
    double speakingRate = 0.85,
    double pitch = 0.0,
    String audioFormat = 'OGG_OPUS',
  }) async {
    try {
      print('🎵 Repository: Synthesizing text to speech...'); // Debug log
      final audioBytes = await _apiService.synthesizeTextToSpeech(
        text: text,
        language: language,
        speakingRate: speakingRate,
        pitch: pitch,
        audioFormat: audioFormat,
      );
      
      print('🎵 Repository: Text-to-speech synthesis successful'); // Debug log
      return audioBytes;
    } catch (e) {
      print('🎵 Repository: Error synthesizing text to speech: $e'); // Debug log
      rethrow;
    }
  }
}
