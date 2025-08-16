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
  final Record _audioRecorder = Record();
  final Uuid _uuid = const Uuid();
  String? _currentRecordingPath;
  Timer? _recordingTimer;
  Timer? _durationTimer;
  static const int maxRecordingDuration = 15; // 15 seconds

  ChatCubit(this._repository) : super(const ChatState()) {
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      emit(state.copyWith(isLoading: true));
      final history = await _repository.loadChatHistory();
      emit(state.copyWith(
        messages: history,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load chat history: $e',
      ));
    }
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

        await _audioRecorder.start(
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

  void clearError() {
    emit(state.copyWith(error: null));
  }

  void clearChat() {
    emit(state.copyWith(messages: []));
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    _durationTimer?.cancel();
    _audioRecorder.stop();
    return super.close();
  }
}