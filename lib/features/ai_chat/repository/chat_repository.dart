import '../service/chat_api_service.dart';
import '../model/chat_message.dart';

class ChatRepository {
  final ChatApiService _apiService;

  ChatRepository(this._apiService);

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'I\'m having trouble connecting right now. Please check your internet and try again.';
    } else if (errorString.contains('timeout')) {
      return 'I\'m taking too long to respond. Please try again.';
    } else if (errorString.contains('genericerror') || errorString.contains('generic error')) {
      return 'Something went wrong on my end. Please try again in a moment.';
    } else if (errorString.contains('unauthorized') || errorString.contains('403') || errorString.contains('401')) {
      return 'I\'m having authentication issues. Please try again later.';
    } else if (errorString.contains('server') || errorString.contains('500')) {
      return 'I\'m experiencing technical difficulties. Please try again later.';
    } else if (errorString.contains('not found') || errorString.contains('404')) {
      return 'I couldn\'t find the information you requested. Please try again.';
    } else {
      return 'I\'m having trouble right now. Please try again in a moment.';
    }
  }

  /// Send text message and get AI response
  Future<ChatMessage> sendTextMessage({
    required String message,
    required String language,
  }) async {
    try {

      
      final response = await _apiService.sendTextMessage(
        message: message,
        language: language,
      );
      


      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response['message'] ?? 'No response received',
        isUser: false,
        timestamp: DateTime.now(),
        language: response['language'] ?? language, // Use detected language
        messageType: MessageType.text,
      );
    } catch (e) {

      
      // Return user-friendly error message as AI response
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: _getUserFriendlyErrorMessage(e),
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );
    }
  }

  /// Send voice message and get AI response
  /// Returns a Map with 'userMessage' and 'aiMessage' keys
  Future<Map<String, ChatMessage>> sendVoiceMessage({
    required String audioFilePath,
    required String language,
  }) async {
    try {
      final response = await _apiService.sendVoiceMessage(
        audioFilePath: audioFilePath,
        language: language,
      );

      final transcript = response['transcript'] ?? 'Audio transcribed';
      final aiResponse = response['message'] ?? 'No response received';
      final detectedLanguage = response['language'] ?? language;

      // Create user message with transcript text (not audio)
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: transcript,
        isUser: true,
        timestamp: DateTime.now(),
        language: detectedLanguage,
        messageType: MessageType.text, // Changed from voice to text
      );

      // Create AI response message
      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        language: detectedLanguage,
        messageType: MessageType.text,
      );

      return {
        'userMessage': userMessage,
        'aiMessage': aiMessage,
      };
    } catch (e) {

      
      // Create error user message and AI error response
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Voice message (transcription failed)',
        isUser: true,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );

      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: _getUserFriendlyErrorMessage(e),
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
      );

      return {
        'userMessage': userMessage,
        'aiMessage': aiMessage,
      };
    }
  }

  /// Load chat history from API with pagination
  Future<Map<String, dynamic>> loadChatHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {

      final historyData = await _apiService.getChatHistory(
        page: page,
        pageSize: pageSize,
      );
      

      return historyData;
    } catch (e) {

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

      final audioBytes = await _apiService.synthesizeTextToSpeech(
        text: text,
        language: language,
        speakingRate: speakingRate,
        pitch: pitch,
        audioFormat: audioFormat,
      );
      

      return audioBytes;
    } catch (e) {

      rethrow;
    }
  }
}
