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
      return 'We encountered a problem processing your request.Our team has been notified and is investigating.';
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
      
      // Ensure response is properly typed
      final Map<String, dynamic> responseMap = response as Map<String, dynamic>;

      return ChatMessage(
        id: responseMap['assistant_message_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        message: responseMap['message'] ?? 'No response received',
        isUser: false,
        timestamp: DateTime.now(),
        language: responseMap['language'] ?? language, // Use detected language
        messageType: MessageType.text,
        reported: false, // New messages are not reported
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
        reported: false, // Error messages are not reported
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
      
      // Ensure response is properly typed
      final Map<String, dynamic> responseMap = response as Map<String, dynamic>;

      final userMessage = ChatMessage(
        id: responseMap['userMessage']?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        message: responseMap['userMessage']?['message'] ?? 'Voice message',
        isUser: true,
        timestamp: DateTime.now(),
        language: responseMap['userMessage']?['language'] ?? language,
        messageType: MessageType.voice,
        reported: false, // User messages are not reported
      );

      final aiMessage = ChatMessage(
        id: responseMap['aiMessage']?['assistant_message_id'] ?? (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: responseMap['aiMessage']?['message'] ?? 'No response received',
        isUser: false,
        timestamp: DateTime.now(),
        language: responseMap['aiMessage']?['language'] ?? language,
        messageType: MessageType.text,
        reported: false, // New messages are not reported
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
        reported: false, // Error user messages are not reported
      );

      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: _getUserFriendlyErrorMessage(e),
        isUser: false,
        timestamp: DateTime.now(),
        language: language,
        messageType: MessageType.text,
        reported: false, // Error AI messages are not reported
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

  /// Report a message
  /// Returns true if report was successful
  Future<bool> reportMessage({
    required String messageId,
    String? feedbackType = 'inappropriate_content',
    String? additionalFeedback,
  }) async {
    try {
      // Get user ID from secure storage
      final userId = await _apiService.getUserId();
      
      final success = await _apiService.reportMessage(
        messageId: messageId,
        userId: userId,
        reason: feedbackType,
        additionalFeedback: additionalFeedback,
      );
      
      return success;
    } catch (e) {
      rethrow;
    }
  }
}
