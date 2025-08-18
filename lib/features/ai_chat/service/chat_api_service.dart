import 'dart:io';
import '../../../data/network/api_service.dart';
import '../../../data/model/result.dart';
import '../../../data/network/api_urls.dart';
import '../../../data/storage/secured_shared_preferences.dart';
import '../../../utils/app_string.dart';

class ChatApiService {
  final ApiService _apiService;
  final SecuredSharedPreferences _securePrefs;

  ChatApiService(this._apiService, this._securePrefs);

  /// Send text message to AI chat API
  Future<String> sendTextMessage({
    required String message,
    required String language,
  }) async {
    try {
      // Get user ID from secure storage
      final userId = await _securePrefs.get(AppString.sessionKey.userId) ?? '123';
     // Get xApiKey from secure storage
      final xApiKey = ApiUrls.fetchedChatBotXApiKEY;

      // Real API endpoint
      const String endpoint = 'https://groone-bot-api.letsgro.co/query-text';
      
      final requestBody = {
        'text': message,
        'language': _mapLanguageCode(language),
        'user_id': userId,
        'catalog_id': 'groone',
      };

      // Add custom headers with X-API-Key
      final customHeaders = {
        'X-API-Key': xApiKey,
      };
      
      final result = await _apiService.post(
        endpoint,
        body: requestBody,
        customHeaders: customHeaders,
      );

      // Handle Result<dynamic> return type
      if (result is Success) {
        final responseData = result.value;
        print('🤖 AI API Response: $responseData'); // Debug log
        
        if (responseData is Map<String, dynamic>) {
          final status = responseData['status'] as String?;
          
          if (status == 'success') {
            final data = responseData['data'] as Map<String, dynamic>?;
            if (data != null) {
              final llmResponse = data['llm_response'] as String?;
              return llmResponse ?? 'No response received from AI';
            }
          }
          
          // Handle error response
          final message = responseData['message'] as String?;
          throw Exception(message ?? 'API returned error status');
        }
        throw Exception('Invalid response format from API');
      } else if (result is Error) {
        throw Exception(result.type.toString());
      } else {
        throw Exception('Unknown response type');
      }
    } catch (e) {
      print('🤖 Error in AI API call: $e'); // Debug log
      
      // Handle specific error cases
      if (e.toString().contains('400')) {
        throw Exception('Invalid message format');
      } else if (e.toString().contains('401')) {
        throw Exception('Authentication failed');
      } else if (e.toString().contains('429')) {
        throw Exception('Too many requests. Please try again later');
      } else {
        throw Exception('Failed to send text message: $e');
      }
    }
  }
  
  /// Map language code to API format
  String _mapLanguageCode(String language) {
    switch (language) {
      case 'hi':
        return 'hi-IN';
      case 'ta':
        return 'ta-IN';
      case 'en':
      default:
        return 'en-IN';
    }
  }

  /// Send voice message to AI chat API
  Future<String> sendVoiceMessage({
    required String audioFilePath,
    required String language,
  }) async {
    try {
      // Get user ID from secure storage
      final userId = await _securePrefs.get(AppString.sessionKey.userId) ?? '123';
      // Get xApiKey from secure storage
      final xApiKey = ApiUrls.fetchedChatBotXApiKEY;
      
      // Real API endpoint for voice transcription
      const String endpoint = 'https://groone-bot-api.letsgro.co/transcribe';
      
      // Create form data for file upload
      final file = File(audioFilePath);
      if (!await file.exists()) {
        throw Exception('Audio file not found');
      }

      // Add custom headers with X-API-Key
      final customHeaders = {
        'X-API-Key': xApiKey,
      };

      // Use multipart for file upload with correct field name 'file' (singular)
      final result = await _apiService.multipart(
        endpoint,
        [file], // files as positional parameter
        fields: {
          'language': _mapLanguageCode(language),
          'user_id': userId,
          'catalog_id': 'groone',
        },
        pathName: 'file', // API expects 'file' not 'files'
        customHeaders: customHeaders,
      );

      // Handle Result<dynamic> return type
      if (result is Success) {
        final responseData = result.value;
        print('🤖 Transcribe API Response: $responseData'); // Debug log
        
        if (responseData is Map<String, dynamic>) {
          final status = responseData['status'] as String?;
          
          if (status == 'success') {
            final data = responseData['data'] as Map<String, dynamic>?;
            if (data != null) {
              // Transcribe API typically returns transcription text
              final transcription = data['transcript'] as String?;
              final llmResponse = data['llm_response'] as String?;
              
              // Check for common transcription errors and provide helpful messages
              if (transcription != null) {
                final lowerTranscription = transcription.toLowerCase();
                
                if (lowerTranscription.contains('no speech recognized')) {
                  return 'No speech recognized. Please try again with a clearer voice message.';
                } else if (lowerTranscription.contains('unclear') || lowerTranscription.contains('unintelligible')) {
                  return 'Speech was unclear. Please try again with clearer pronunciation.';
                } else if (lowerTranscription.contains('too quiet') || lowerTranscription.contains('low volume')) {
                  return 'Voice was too quiet. Please speak louder and try again.';
                } else if (lowerTranscription.contains('background noise') || lowerTranscription.contains('noise')) {
                  return 'Too much background noise. Please record in a quieter environment.';
                }
              }
              
              // Return AI response if available, otherwise transcription
              if (llmResponse != null && llmResponse.isNotEmpty) {
                return llmResponse;
              } else if (transcription != null && transcription.isNotEmpty) {
                return 'Transcription: $transcription';
              } else {
                return 'Voice message received but no response generated';
              }
            }
          }
          
          // Handle error response
          final message = responseData['message'] as String?;
          throw Exception(message ?? 'API returned error status');
        }
        throw Exception('Invalid response format from API');
      } else if (result is Error) {
        throw Exception(result.type.toString());
      } else {
        throw Exception('Unknown response type');
      }
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('400')) {
        throw Exception('Invalid audio format');
      } else if (e.toString().contains('401')) {
        throw Exception('Authentication failed');
      } else if (e.toString().contains('413')) {
        throw Exception('Audio file too large');
      } else if (e.toString().contains('429')) {
        throw Exception('Too many requests. Please try again later');
      } else {
        throw Exception('Failed to send voice message: $e');
      }
    }
  }

  /// Get chat history from API with pagination
  Future<Map<String, dynamic>> getChatHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // Get user ID from secure storage
      final userId = await _securePrefs.get(AppString.sessionKey.userId) ?? '';
      // Get xApiKey from secure storage
      final xApiKey = ApiUrls.fetchedChatBotXApiKEY;
      
      // Real API endpoint for chat history with pagination
      final String endpoint = 'https://groone-bot-api.letsgro.co/messages/$userId/groone';
      
      // Add custom headers with X-API-Key
      final customHeaders = {
        'X-API-Key': xApiKey,
      };
      
      final result = await _apiService.get(
        endpoint,
        queryParams: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
        customHeaders: customHeaders,
      );

      // Handle Result<dynamic> return type
      if (result is Success) {
        final data = result.value;
        if (data is Map<String, dynamic>) {
          return data;
        }
        throw Exception('Invalid response format from API');
      } else if (result is Error) {
        throw Exception(result.type.toString());
      } else {
        throw Exception('Unknown response type');
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        throw Exception('Authentication failed');
      } else {
        throw Exception('Failed to get chat history: $e');
      }
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
      print('🎵 Synthesizing text to speech: $text'); // Debug log
      
      // Get xApiKey from secure storage
      final xApiKey = ApiUrls.fetchedChatBotXApiKEY;
      
      // Real API endpoint for text-to-speech synthesis
      const String endpoint = 'https://groone-bot-api.letsgro.co/synthesize';
      
      // Add custom headers with X-API-Key
      final customHeaders = {
        'X-API-Key': xApiKey,
        'Content-Type': 'application/json',
      };
      
      // Request body
      final requestBody = {
        'text': text,
        'language': language,
        'speaking_rate': speakingRate,
        'pitch': pitch,
        'audio_format': audioFormat,
      };
      
      final result = await _apiService.post(
        endpoint,
        body: requestBody,
        customHeaders: customHeaders,
      );

      // Handle Result<dynamic> return type
      if (result is Success) {
        final data = result.value;
        if (data is Map<String, dynamic>) {
          final status = data['status'] as String?;
          final message = data['message'] as String?;
          
          if (status == 'success') {
            final responseData = data['data'] as Map<String, dynamic>?;
            if (responseData != null) {
              final audioBytes = responseData['audio_bytes'] as String?;
              if (audioBytes != null && audioBytes.isNotEmpty) {
                print('🎵 Text-to-speech synthesis successful'); // Debug log
                return audioBytes;
              } else {
                throw Exception('No audio data received');
              }
            } else {
              throw Exception('Invalid response data format');
            }
          } else {
            throw Exception(message ?? 'Synthesis failed');
          }
        }
        throw Exception('Invalid response format from API');
      } else if (result is Error) {
        throw Exception(result.type.toString());
      } else {
        throw Exception('Unknown response type');
      }
    } catch (e) {
      print('🎵 Text-to-speech synthesis error: $e'); // Debug log
      
      // Handle specific error cases
      if (e.toString().contains('400')) {
        throw Exception('Invalid text or parameters');
      } else if (e.toString().contains('401')) {
        throw Exception('Authentication failed');
      } else if (e.toString().contains('429')) {
        throw Exception('Too many requests. Please try again later');
      } else {
        throw Exception('Failed to synthesize text to speech: $e');
      }
    }
  }
}