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
  int _pageSize = 20;
  bool _hasMoreMessages = true;
  bool _isLoadingHistory = false;

  ChatCubit(this._repository) : super(const ChatState());

  Future<void> _loadChatHistory() async {
    try {
      emit(state.copyWith(isLoading: true));
      final history = await _repository.loadChatHistory(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (history is Map<String, dynamic>) {
        final data = history['data'] as Map<String, dynamic>?;
        if (data != null) {
          final messages = data['messages'] as List<dynamic>?;
          final hasMore = data['has_more'] as bool? ?? false;
          final currentPage = data['page'] as int? ?? 1;

          if (messages != null) {
            final List<ChatMessage> chatMessages = [];

            for (final messageData in messages) {
              try {
                // Convert API message format to ChatMessage
                final message = _convertApiMessageToChatMessage(messageData);
                chatMessages.add(message);
              } catch (e) {
                print('📚 Error converting message: $e'); // Debug log
                continue;
              }
            }

            // Sort messages by timestamp to ensure chronological order (oldest first)
            chatMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

            // For initial load: replace all messages
            // For pagination: add older messages to the beginning
            final updatedMessages = state.messages.isEmpty
                ? chatMessages  // Initial load - set messages directly
                : [...chatMessages, ...state.messages]; // Pagination - add older messages at top

            _hasMoreMessages = hasMore;

            emit(state.copyWith(
              messages: updatedMessages,
              isLoading: false,
              hasMoreMessages: _hasMoreMessages,
              pageNo: _currentPage,
            ));
            _currentPage = currentPage + 1;


            print('📚 Loaded ${chatMessages.length} messages. Total: ${updatedMessages.length}. Has more: $_hasMoreMessages'); // Debug log
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load chat history: $e',
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
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      message: audioPath,
      isUser: true,
      timestamp: DateTime.now(),
      language: state.selectedLanguage.code,
      messageType: MessageType.voice,
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);

    emit(state.copyWith(
      messages: updatedMessages,
      isLoading: true,
      error: null,
    ));

    // Call voice API
    _callVoiceAPI(audioPath);
  }

  Future<void> _callTextAPI(String userMessage) async {
    try {
      print('🚀 Starting API call for: $userMessage'); // Debug log

      // Show typing indicator
      emit(state.copyWith(
        isTyping: true,
        isLoading: false,
        clearError: true,
      ));

      // Call the real API
      final aiMessage = await _repository.sendTextMessage(
        message: userMessage,
        language: state.selectedLanguage.code,
      );

      print('🚀 Received AI response: ${aiMessage.message}'); // Debug log

      final updatedMessages = List<ChatMessage>.from(state.messages)
        ..add(aiMessage);

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
        isTyping: false,
      ));
    } catch (e) {
      print('🚀 API call error: $e'); // Debug log

      emit(state.copyWith(
        isLoading: false,
        isTyping: false,
        error: 'Failed to send message: $e',
      ));
    }
  }

  Future<void> _callVoiceAPI(String audioPath) async {
    try {
      print('🎤 Starting voice API call for: $audioPath'); // Debug log

      // Show typing indicator for voice transcription
      emit(state.copyWith(
        isTyping: true,
        isLoading: false,
        clearError: true,
      ));

      final aiMessage = await _repository.sendVoiceMessage(
        audioFilePath: audioPath,
        language: state.selectedLanguage.code,
      );

      print('🎤 Received voice API response: ${aiMessage.message}'); // Debug log

      final updatedMessages = List<ChatMessage>.from(state.messages)
        ..add(aiMessage);

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
        isTyping: false,
      ));
    } catch (e) {
      print('🎤 Voice API call error: $e'); // Debug log

      emit(state.copyWith(
        isLoading: false,
        isTyping: false,
        error: 'Failed to send voice message: $e',
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
      print('Deleting recorded audio: ${state.recordedAudioPath}'); // Debug log

      if (state.recordedAudioPath != null) {
        final file = File(state.recordedAudioPath!);
        if (file.existsSync()) {
          file.deleteSync();
          print('Audio file deleted successfully'); // Debug log
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
      print('State reset to normal mode'); // Debug log
    } catch (e) {
      print('Error deleting recording: $e'); // Debug log
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
  Future<String> synthesizeTextToSpeech(String text) async {
    try {
      print('🎵 Cubit: Starting text-to-speech synthesis for: $text'); // Debug log

      // Show loading state
      emit(state.copyWith(isLoading: true,pageNo: 2,));

      // Call the repository to synthesize text to speech
      final audioBytes = await _repository.synthesizeTextToSpeech(
        text: text,
        language: state.selectedLanguage.code,
        speakingRate: 0.85,
        pitch: 0.0,
        audioFormat: 'OGG_OPUS',
      );

      print('🎵 Cubit: Text-to-speech synthesis successful'); // Debug log

      // Emit success state
      emit(state.copyWith(
        isLoading: false,
        clearError: true,
        pageNo: 2,
      ));

      // Return the audio bytes for playback
      return audioBytes;
    } catch (e) {
      print('🎵 Cubit: Text-to-speech synthesis error: $e'); // Debug log

      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to synthesize text to speech: $e',
        pageNo: 2,
      ));

      rethrow;
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  /// Load more chat history (pagination)
  Future<void> loadMoreChatHistory() async {
    if (_isLoadingHistory || !_hasMoreMessages) return;

    try {
      _isLoadingHistory = true;

      print('📚 Loading more chat history: page $_currentPage, size $_pageSize'); // Debug log

      final historyData = await _repository.loadChatHistory(
        page: _currentPage,
        pageSize: _pageSize,
      );

      print('📚 Cubit received history data: $historyData'); // Debug log

      if (historyData is Map<String, dynamic>) {
        final data = historyData['data'] as Map<String, dynamic>?;
        if (data != null) {
          final messages = data['messages'] as List<dynamic>?;
          final hasMore = data['has_more'] as bool? ?? false;
          final currentPage = data['page'] as int? ?? 1;

          if (messages != null) {
            final List<ChatMessage> chatMessages = [];

            for (final messageData in messages) {
              try {
                // Convert API message format to ChatMessage
                final message = _convertApiMessageToChatMessage(messageData);
                chatMessages.add(message);
              } catch (e) {
                print('📚 Error converting message: $e'); // Debug log
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
              pageNo: _currentPage,
            ));
            _currentPage = currentPage + 1;
            print('📚 Loaded ${chatMessages.length} messages. Total: ${updatedMessages.length}. Has more: $_hasMoreMessages'); // Debug log
          }
        }
      }
    } catch (e) {
      print('📚 Error loading more chat history: $e'); // Debug log
      emit(state.copyWith(
        error: 'Failed to load more chat history: $e',
        isLoading: false,
      ));
    } finally {
      _isLoadingHistory = false;
    }
  }

  /// Convert API message format to ChatMessage
  ChatMessage _convertApiMessageToChatMessage(Map<String, dynamic> messageData) {
    // Based on actual API response structure
    final id = DateTime.now().millisecondsSinceEpoch.toString(); // Generate unique ID
    final message = messageData['content'] ?? '';
    final isUser = messageData['role'] == 'user';
    final timestamp = messageData['timestamp'] != null
        ? DateTime.parse(messageData['timestamp'].toString())
        : DateTime.now();
    final language = messageData['language'] ?? 'en';
    final messageType = MessageType.text; // Default to text for now

    return ChatMessage(
      id: id,
      message: message,
      isUser: isUser,
      timestamp: timestamp,
      language: language,
      messageType: messageType,
    );
  }

  void clearChat() {
    emit(state.copyWith(
      messages: [],
      hasMoreMessages: true,
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