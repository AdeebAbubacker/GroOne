import 'package:equatable/equatable.dart';
import '../model/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final ChatLanguage selectedLanguage;
  final bool isLoading;
  final bool isRecording;
  final bool isTyping; // AI is typing response
  final bool isProcessingVoice; // Voice message is being transcribed
  final bool hasMoreMessages; // Whether there are more messages to load
  final String? recordedAudioPath;
  final int recordingDuration;
  final String? error;
  final int pageNo;

  const ChatState({
    this.messages = const [],
    this.selectedLanguage = ChatLanguage.english,
    this.isLoading = false,
    this.isRecording = false,
    this.isTyping = false,
    this.isProcessingVoice = false,
    this.hasMoreMessages = true,
    this.recordedAudioPath,
    this.recordingDuration = 0,
    this.pageNo =1,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatLanguage? selectedLanguage,
    bool? isLoading,
    bool? isRecording,
    bool? isTyping,
    bool? isProcessingVoice,
    bool? hasMoreMessages,
    String? recordedAudioPath,
    bool clearRecordedAudioPath = false,
    int? recordingDuration,
    int? pageNo = 1,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
      isRecording: isRecording ?? this.isRecording,
      isTyping: isTyping ?? this.isTyping,
      isProcessingVoice: isProcessingVoice ?? this.isProcessingVoice,
      pageNo: pageNo ?? this.pageNo,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
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
        isProcessingVoice,
        hasMoreMessages,
        recordedAudioPath,
        recordingDuration,
        error,
      ];
}
