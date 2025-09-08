import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../model/chat_message.dart';
import '../repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final Uuid _uuid = const Uuid();
  String? _currentRecordingPath;
  Timer? _recordingTimer;
  Timer? _durationTimer;
  static const int maxRecordingDuration = 15; // 15 seconds
  
  // Pagination variables
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreMessages = true;
  bool _isLoadingHistory = false;

  ChatCubit(this._repository) : super(const ChatState());

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Unable to connect. Please check your internet connection and try again.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('genericerror') || errorString.contains('generic error')) {
      return 'We encountered a problem processing your request.Our team has been notified and is investigating.';
    } else if (errorString.contains('unauthorized') || errorString.contains('403') || errorString.contains('401')) {
      return 'Access denied. Please check your credentials.';
    } else if (errorString.contains('server') || errorString.contains('500')) {
      return 'Server error. Please try again later.';
    } else if (errorString.contains('not found') || errorString.contains('404')) {
      return 'Requested information not found.';
    } else {
      return 'Unable to load chat history. Please try again.';
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      emit(state.copyWith(isLoading: true));
      final history = await _repository.loadChatHistory(
        page: _currentPage,
        pageSize: _pageSize,
      );

      final data = history['data'] as Map<String, dynamic>?;
      if (data != null) {
        final messages = data['messages'] as List<dynamic>?;
        final hasMore = data['has_more'] as bool? ?? false;
        final currentPage = data['page'] as int? ?? 1;
        
        // Extract rate limit information from chat history if available
        final rateLimitData = data['rate_limit'] as Map<String, dynamic>?;
        int? todaysCount;
        int? dailyLimit;
        
        if (rateLimitData != null) {
          todaysCount = rateLimitData['current_count'] as int?;
          dailyLimit = rateLimitData['daily_limit'] as int?;
        }

        if (messages != null) {
          final List<ChatMessage> chatMessages = [];

          for (final messageData in messages) {
            try {
              // Convert API message format to ChatMessage
              final message = _convertApiMessageToChatMessage(messageData);
              chatMessages.add(message);
              
              // Debug individual message parsing
              print('   📝 Message: ${message.isUser ? 'USER' : 'AI'} - ID: ${message.id} - Reported: ${message.reported}');
            } catch (e) {
              print('   ❌ Error parsing message: $e');
              continue;
            }
          }

          // Sort messages by timestamp to ensure chronological order (oldest first)
          chatMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          // Merge with existing messages, preserving reported status
          final Map<String, ChatMessage> existingMessagesMap = {};
          for (final msg in state.messages) {
            existingMessagesMap[msg.id] = msg;
          }

          // Update reported status from existing messages if available
          for (final newMessage in chatMessages) {
            final existingMessage = existingMessagesMap[newMessage.id];
            if (existingMessage != null && existingMessage.reported) {
              // Preserve the reported status from existing message
              chatMessages[chatMessages.indexOf(newMessage)] = newMessage.copyWith(
                reported: true,
              );
              print('🔄 Preserved reported status for message: ${newMessage.id}');
            }
          }

          print('📊 Message status after merging:');
          for (final msg in chatMessages) {
            if (!msg.isUser) {
              print('   - AI Message ${msg.id}: reported = ${msg.reported}');
            }
          }

          // Determine if this is initial load or pagination
          final isInitialLoad = state.messages.isEmpty;
          final updatedMessages = isInitialLoad 
              ? chatMessages  // Initial load - use messages as-is
              : [...chatMessages, ...state.messages]; // Pagination - add older messages at top
          
          print('📱 Load type: ${isInitialLoad ? "Initial" : "Pagination"}');
          print('📱 Messages count: ${updatedMessages.length}');
          print('📱 AI Messages with reported status:');
          for (final msg in updatedMessages) {
            if (!msg.isUser) {
              print('   - ${msg.id}: reported = ${msg.reported}');
            }
          }

          _hasMoreMessages = hasMore;

          emit(state.copyWith(
            messages: updatedMessages,
            isLoading: false,
            hasMoreMessages: _hasMoreMessages,
            pageNo: _currentPage,
            isInitialLoadingComplete: isInitialLoad, // Set to true for initial load
            todaysChatCount: todaysCount ?? state.todaysChatCount,
            dailyChatLimit: dailyLimit ?? state.dailyChatLimit,
          ));
          _currentPage = currentPage + 1;


        }
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: _getUserFriendlyErrorMessage(e),
      ));
    }
  }

  /// Load chat history with refresh option
  Future<void> loadChatHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreMessages = true;
      emit(state.copyWith(messages: []));
    }

    await _loadChatHistory();
  }

  void sendTextMessage(String message) {
    if (message.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      message: message.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      language: state.selectedLanguage.code,
      messageType: MessageType.text,
      reported: false, // User messages are not reported
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);

    emit(state.copyWith(
      messages: updatedMessages,
      isLoading: true,
      error: null,
    ));

    // Call text API
    _callTextAPI(message.trim());
  }

  void sendVoiceMessage(String audioPath) {
    // Don't add user message here - repository will create both user transcript and AI response
    emit(state.copyWith(
      isProcessingVoice: true,
      isLoading: true,
      error: null,
    ));

    // Call voice API
    _callVoiceAPI(audioPath);
  }

  Future<void> _callTextAPI(String userMessage) async {
    try {


      // Show typing indicator
      emit(state.copyWith(
        isTyping: true,
        isLoading: false,
        clearError: true,
      ));

      // Call the real API - now returns both message and rate limit data
      final response = await _repository.sendTextMessage(
        message: userMessage,
        language: state.selectedLanguage.code,
      );

      // Extract chat message and rate limit data
      final aiMessage = response['message'] as ChatMessage;
      final rateLimitData = response['rate_limit'] as Map<String, dynamic>?;

      // Extract rate limit information from actual API response structure
      int? todaysCount;
      int? dailyLimit;
      
      if (rateLimitData != null) {
        todaysCount = rateLimitData['current_count'] as int?;
        dailyLimit = rateLimitData['daily_limit'] as int?;
      }

      final updatedMessages = List<ChatMessage>.from(state.messages)
        ..add(aiMessage);

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
        isTyping: false,
        todaysChatCount: todaysCount ?? state.todaysChatCount,
        dailyChatLimit: dailyLimit ?? state.dailyChatLimit,
      ));
    } catch (e) {


      emit(state.copyWith(
        isLoading: false,
        isTyping: false,
        error: _getUserFriendlyErrorMessage(e),
      ));
    }
  }

  Future<void> _callVoiceAPI(String audioPath) async {
    try {


      // Show typing indicator for voice transcription
      emit(state.copyWith(
        isTyping: true,
        isLoading: false,
        clearError: true,
      ));

      final result = await _repository.sendVoiceMessage(
        audioFilePath: audioPath,
        language: state.selectedLanguage.code,
      );

      final userMessage = result['userMessage'] as ChatMessage;
      final aiMessage = result['aiMessage'] as ChatMessage;
      final rateLimitData = result['rate_limit'] as Map<String, dynamic>?;

      // Extract rate limit information from actual API response structure
      int? todaysCount;
      int? dailyLimit;
      
      if (rateLimitData != null) {
        todaysCount = rateLimitData['current_count'] as int?;
        dailyLimit = rateLimitData['daily_limit'] as int?;
      }

      // Add both user transcript message and AI response
      final updatedMessages = List<ChatMessage>.from(state.messages)
        ..add(userMessage)
        ..add(aiMessage);

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
        isTyping: false,
        isProcessingVoice: false,
        todaysChatCount: todaysCount ?? state.todaysChatCount,
        dailyChatLimit: dailyLimit ?? state.dailyChatLimit,
      ));
    } catch (e) {


      emit(state.copyWith(
        isLoading: false,
        isTyping: false,
        isProcessingVoice: false,
        error: _getUserFriendlyErrorMessage(e),
      ));
    }
  }

  void changeLanguage(ChatLanguage language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final fileName = 'voice_${_uuid.v4()}.m4a';
        _currentRecordingPath = path.join(directory.path, fileName);

        await _audioRecorder.start(const RecordConfig(),
          path: _currentRecordingPath!,
        );

        emit(state.copyWith(
          isRecording: true,
          recordingDuration: 0,
          clearRecordedAudioPath: true,
          clearError: true,
        ));

        // Start duration timer
        _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          final newDuration = state.recordingDuration + 1;
          emit(state.copyWith(recordingDuration: newDuration));
        });

        // Auto-stop after 15 seconds
        _recordingTimer = Timer(const Duration(seconds: maxRecordingDuration), () {
          stopRecording();
        });
      } else {
        emit(state.copyWith(error: 'Microphone permission required'));
      }
    } catch (e) {
      emit(state.copyWith(
        isRecording: false,
        error: 'Failed to start recording: $e',
      ));
    }
  }

  Future<void> stopRecording() async {
    try {
      _recordingTimer?.cancel();
      _durationTimer?.cancel();

      final recordedPath = await _audioRecorder.stop();

      if (recordedPath != null && _currentRecordingPath != null) {
        // Show preview with recorded audio
        emit(state.copyWith(
          isRecording: false,
          recordedAudioPath: _currentRecordingPath,
        ));
      } else {
        emit(state.copyWith(
          isRecording: false,
          clearRecordedAudioPath: true,
          recordingDuration: 0,
        ));
      }
    } catch (e) {
      _recordingTimer?.cancel();
      _durationTimer?.cancel();
      emit(state.copyWith(
        isRecording: false,
        clearRecordedAudioPath: true,
        recordingDuration: 0,
        error: 'Failed to stop recording: $e',
      ));
    }
  }

  Future<void> cancelRecording() async {
    try {
      _recordingTimer?.cancel();
      _durationTimer?.cancel();

      await _audioRecorder.stop();

      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      emit(state.copyWith(
        isRecording: false,
        clearRecordedAudioPath: true,
        recordingDuration: 0,
      ));

      _currentRecordingPath = null;
    } catch (e) {
      emit(state.copyWith(
        isRecording: false,
        recordedAudioPath: null,
        recordingDuration: 0,
        error: 'Failed to cancel recording: $e',
      ));
    }
  }

  void deleteRecordedAudio() {
    try {


      if (state.recordedAudioPath != null) {
        final file = File(state.recordedAudioPath!);
        if (file.existsSync()) {
          file.deleteSync();

        }
      }

      // Reset state completely to go back to normal mode
      emit(state.copyWith(
        clearRecordedAudioPath: true,
        recordingDuration: 0,
        isRecording: false,
        isLoading: false,
        clearError: true,
      ));

      _currentRecordingPath = null;

    } catch (e) {

      emit(state.copyWith(
        clearRecordedAudioPath: true,
        recordingDuration: 0,
        isRecording: false,
        error: 'Failed to delete recording: $e',
      ));
    }
  }

  void sendRecordedAudio() {
    if (state.recordedAudioPath != null) {
      sendVoiceMessage(state.recordedAudioPath!);

      // Clear the recorded audio after sending
      emit(state.copyWith(
        clearRecordedAudioPath: true,
        recordingDuration: 0,
      ));

      _currentRecordingPath = null;
    }
  }

  /// Synthesize text to speech
  Future<String> synthesizeTextToSpeech(String text, {String? language}) async {
    try {
      final langCode = language ?? state.selectedLanguage.code;


      // Show loading state
      emit(state.copyWith(isLoading: true,pageNo: 2,));

      // Call the repository to synthesize text to speech
      final audioBytes = await _repository.synthesizeTextToSpeech(
        text: text,
        language: langCode,
        speakingRate: 0.85,
        pitch: 0.0,
        audioFormat: 'OGG_OPUS',
      );


      // Emit success state
      emit(state.copyWith(
        isLoading: false,
        clearError: true,
        pageNo: 2,
      ));

      // Return the audio bytes for playback
      return audioBytes;
    } catch (e) {


      emit(state.copyWith(
        isLoading: false,
        error: _getUserFriendlyErrorMessage(e),
        pageNo: 2,
      ));

      rethrow;
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  /// Clear success message
  void clearSuccessMessage() {
    emit(state.copyWith(clearSuccessMessage: true));
  }

  /// Report a message
  /// Updates the message's reported status if successful
  Future<void> reportMessage(String messageId, {String? feedbackType}) async {
    print('🎯 [CUBIT] Report message called...');
    print('🎯 [CUBIT] Message ID: $messageId');
    print('🎯 [CUBIT] Feedback Type: $feedbackType');
    
    try {
      // Find the message to report
      final messageIndex = state.messages.indexWhere((msg) => msg.id == messageId);
      if (messageIndex == -1) {
        print('🎯 [CUBIT] Message not found: $messageId');
        emit(state.copyWith(error: 'Message not found'));
        return;
      }

      print('🎯 [CUBIT] Found message at index: $messageIndex');
      print('🎯 [CUBIT] Current reported status: ${state.messages[messageIndex].reported}');

      // Call the repository to report the message with feedback
      print('🎯 [CUBIT] Calling repository...');
      final response = await _repository.reportMessage(
        messageId: messageId,
        feedbackType: feedbackType ?? 'inappropriate_content',
      );
      
      // Check if report was successful
      final success = response['success'] as bool? ?? false;
      
      print('🎯 [CUBIT] Repository response: $response');
      print('🎯 [CUBIT] Report success: $success');
      
      if (success) {
        // Update the message's reported status based on API response
        final updatedMessages = List<ChatMessage>.from(state.messages);
        final oldReportedStatus = updatedMessages[messageIndex].reported;
        final newReportedStatus = response['is_reported'] as bool? ?? true;
        
        updatedMessages[messageIndex] = updatedMessages[messageIndex].copyWith(
          reported: newReportedStatus,
        );
        
        print('🎯 [CUBIT] Updated message ${messageId}: reported = $oldReportedStatus -> $newReportedStatus');
        
        emit(state.copyWith(
          messages: updatedMessages,
          clearError: true,
          successMessage: 'Thanks you for helping improve Gro AI Saathi',
        ));
        
        print('🎯 [CUBIT] State updated successfully');
      } else {
        print('🎯 [CUBIT] Report failed');
        emit(state.copyWith(error: 'Failed to report message'));
      }
    } catch (e) {
      print('🎯 [CUBIT] Error occurred: $e');
      emit(state.copyWith(error: _getUserFriendlyErrorMessage(e)));
    }
  }

  /// Load more chat history (pagination)
  Future<void> loadMoreChatHistory() async {
    if (_isLoadingHistory || !_hasMoreMessages) return;

    try {
      _isLoadingHistory = true;



      final historyData = await _repository.loadChatHistory(
        page: _currentPage,
        pageSize: _pageSize,
      );



      final data = historyData['data'] as Map<String, dynamic>?;
      if (data != null) {
        final messages = data['messages'] as List<dynamic>?;
        final hasMore = data['has_more'] as bool? ?? false;
        final currentPage = data['page'] as int? ?? 1;
        final totalCount = data['total_count'] as int? ?? 0;
        final pageSize = data['page_size'] as int? ?? _pageSize;
        
        // Extract rate limit information from pagination response if available
        final rateLimitData = data['rate_limit'] as Map<String, dynamic>?;
        int? todaysCount;
        int? dailyLimit;
        
        if (rateLimitData != null) {
          todaysCount = rateLimitData['current_count'] as int?;
          dailyLimit = rateLimitData['daily_limit'] as int?;
        }

        print('📱 Chat History API Response:');
        print('   - Total messages: $totalCount');
        print('   - Current page: $currentPage');
        print('   - Page size: $pageSize');
        print('   - Has more: $hasMore');
        print('   - Messages count: ${messages?.length ?? 0}');

        if (messages != null) {
          final List<ChatMessage> chatMessages = [];

          for (final messageData in messages) {
            try {
              // Convert API message format to ChatMessage
              final message = _convertApiMessageToChatMessage(messageData);
              chatMessages.add(message);
            } catch (e) {

              continue;
            }
          }

          // Sort messages by timestamp to ensure chronological order (oldest first)
          chatMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          // Add older messages to the beginning (top) to maintain scroll position
          final updatedMessages = [...chatMessages, ...state.messages];

          _hasMoreMessages = hasMore;

          // Emit state with new messages and pagination info
          emit(state.copyWith(
            messages: updatedMessages,
            hasMoreMessages: _hasMoreMessages,
            isLoading: false,
            pageNo: currentPage,
            todaysChatCount: todaysCount ?? state.todaysChatCount,
            dailyChatLimit: dailyLimit ?? state.dailyChatLimit,
          ));
          _currentPage = currentPage + 1;

        }
      }
    } catch (e) {

      emit(state.copyWith(
        error: _getUserFriendlyErrorMessage(e),
        isLoading: false,
      ));
    } finally {
      _isLoadingHistory = false;
    }
  }

  /// Convert API message format to ChatMessage
  ChatMessage _convertApiMessageToChatMessage(Map<String, dynamic> messageData) {
    // Based on new chat history API response structure
    final id = messageData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    final message = messageData['content'] ?? '';
    final isUser = messageData['role'] == 'user';
    final timestamp = messageData['timestamp'] != null
        ? DateTime.parse(messageData['timestamp'].toString())
        : DateTime.now();
    final language = messageData['language'] ?? 'en';
    final messageType = MessageType.text; // Default to text for now
    final reported = messageData['is_reported'] ?? false; // Parse new is_reported field

    return ChatMessage(
      id: id,
      message: message,
      isUser: isUser,
      timestamp: timestamp,
      language: language,
      messageType: messageType,
      reported: reported, // Include reported field
    );
  }

  void clearChat() {
    emit(state.copyWith(
      messages: [],
      hasMoreMessages: true,
      isInitialLoadingComplete: false, // Reset initial loading flag
    ));
    _currentPage = 1;
    _hasMoreMessages = true;
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    _durationTimer?.cancel();
    _audioRecorder.stop();
    return super.close();
  }
}