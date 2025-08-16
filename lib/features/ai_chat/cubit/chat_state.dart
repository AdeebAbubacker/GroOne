import 'package:equatable/equatable.dart';
import '../model/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final ChatLanguage selectedLanguage;
  final bool isLoading;
  final bool isRecording;
  final bool isTyping; // AI is typing response
  final String? recordedAudioPath;
  final int recordingDuration;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.selectedLanguage = ChatLanguage.english,
    this.isLoading = false,
    this.isRecording = false,
    this.isTyping = false,
    this.recordedAudioPath,
    this.recordingDuration = 0,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatLanguage? selectedLanguage,
    bool? isLoading,
    bool? isRecording,
    bool? isTyping,
    String? recordedAudioPath,
    bool clearRecordedAudioPath = false,
    int? recordingDuration,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
      isRecording: isRecording ?? this.isRecording,
      isTyping: isTyping ?? this.isTyping,
      recordedAudioPath: clearRecordedAudioPath ? null : (recordedAudioPath ?? this.recordedAudioPath),
      recordingDuration: recordingDuration ?? this.recordingDuration,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        messages,
        selectedLanguage,
        isLoading,
        isRecording,
        isTyping,
        recordedAudioPath,
        recordingDuration,
        error,
      ];
}
